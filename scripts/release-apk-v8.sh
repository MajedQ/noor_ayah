#!/usr/bin/env bash
# Build arm64-v8a release APK and publish via gh (no GitHub Actions).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

discover_flutter_root() {
  local candidates=()
  while IFS= read -r -d '' f; do
    local dir
    dir="$(dirname "$f")"
    if [[ -d "$dir/android" ]] && grep -q '^flutter:' "$f" 2>/dev/null; then
      candidates+=("$dir")
    fi
  done < <(find "$REPO_ROOT" -maxdepth 4 -name pubspec.yaml -print0 2>/dev/null)

  if [[ ${#candidates[@]} -eq 0 ]]; then
    echo "error: no Flutter project (pubspec.yaml + android/) found" >&2
    exit 1
  fi

  for preferred in apps/mobile apps/flutter mobile; do
    for c in "${candidates[@]}"; do
      if [[ "$c" == "$REPO_ROOT/$preferred" ]]; then
        echo "$c"
        return
      fi
    done
  done

  if [[ ${#candidates[@]} -eq 1 ]]; then
    echo "${candidates[0]}"
    return
  fi

  for c in "${candidates[@]}"; do
    if [[ -f "$c/android/app/build.gradle.kts" ]]; then
      echo "$c"
      return
    fi
  done

  echo "${candidates[0]}"
}

FLUTTER_ROOT="$(discover_flutter_root)"
cd "$FLUTTER_ROOT"

PUBSPEC="$FLUTTER_ROOT/pubspec.yaml"
PUBSPEC_NAME="$(grep -E '^name:' "$PUBSPEC" | sed 's/name:[[:space:]]*//' | tr -d "\"'")"
TAG_PREFIX="$(echo "$PUBSPEC_NAME" | tr '_' '-')-v"
APK_BASENAME="$(echo "$PUBSPEC_NAME" | tr '_' '-')"

read_version() {
  local raw
  raw="$(grep -E '^version:' "$PUBSPEC" | sed 's/version:[[:space:]]*//' | tr -d "\"'")"
  if [[ "$raw" == *+* ]]; then
    VERSION_NAME="${raw%%+*}"
    BUILD_NUMBER="${raw#*+}"
  else
    VERSION_NAME="$raw"
    BUILD_NUMBER="0"
  fi
}

bump_version() {
  read_version
  IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION_NAME"
  PATCH=$((PATCH + 1))
  BUILD_NUMBER=$((BUILD_NUMBER + 1))
  VERSION_NAME="${MAJOR}.${MINOR}.${PATCH}"
  NEW_VERSION="${VERSION_NAME}+${BUILD_NUMBER}"

  if grep -qE '^version:' "$PUBSPEC"; then
    sed -i "s/^version:.*/version: ${NEW_VERSION}/" "$PUBSPEC"
  else
    echo "version: ${NEW_VERSION}" >> "$PUBSPEC"
  fi

  if [[ "$FLUTTER_ROOT" == "$REPO_ROOT" ]]; then
    git add "$PUBSPEC"
    git commit -m "chore(release): bump version to ${NEW_VERSION}" || true
  fi
}

bump_version
read_version

APK_FILENAME="${APK_BASENAME}-v${VERSION_NAME}-arm64-v8a.apk"
TAG="${TAG_PREFIX}${VERSION_NAME}"
FULL_VERSION="${VERSION_NAME}+${BUILD_NUMBER}"

echo "==> Flutter root: $FLUTTER_ROOT"
echo "==> Version: $FULL_VERSION"
echo "==> Tag: $TAG"
echo "==> APK: $APK_FILENAME"

flutter pub get
if [[ -f l10n.yaml ]] || [[ -d lib/l10n ]]; then
  flutter gen-l10n 2>/dev/null || true
fi
flutter test

flutter build apk --release --target-platform android-arm64

SRC="$FLUTTER_ROOT/build/app/outputs/flutter-apk/app-release.apk"
DEST="$REPO_ROOT/$APK_FILENAME"
cp "$SRC" "$DEST"

SHA256="$(sha256sum "$DEST" | awk '{print $1}')"
NOTES="## Android APK (arm64-v8a)

| Field | Value |
|---|---|
| File | \`${APK_FILENAME}\` |
| Architecture | arm64-v8a (ARMv8 / 64-bit) |
| Version | ${FULL_VERSION} |
| SHA-256 | \`${SHA256}\` |

Signed with release keystore (private repo)."

cd "$REPO_ROOT"

if gh release view "$TAG" &>/dev/null; then
  gh release upload "$TAG" "$APK_FILENAME" --clobber
  gh release edit "$TAG" --notes "$NOTES"
else
  gh release create "$TAG" "$APK_FILENAME" \
    --title "Noor Ayah ${VERSION_NAME} (arm64-v8a)" \
    --notes "$NOTES"
fi

RELEASE_URL="$(gh release view "$TAG" --json url -q .url)"
ASSET_URL="$(gh release view "$TAG" --json assets -q ".assets[] | select(.name==\"${APK_FILENAME}\") | .url")"

echo ""
echo "Release: $RELEASE_URL"
echo "Direct download: $ASSET_URL"
echo "Version: $FULL_VERSION"
