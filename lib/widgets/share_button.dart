import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/verse_model.dart';
import '../providers/achievements_provider.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

/// زر المشاركة
class ShareButton extends StatelessWidget {
  final VerseModel verse;
  final double size;
  final bool showLabel;

  const ShareButton({
    super.key,
    required this.verse,
    this.size = 24.0,
    this.showLabel = false,
  });

  Future<void> _shareVerse(BuildContext context) async {
    AppHelpers.selectionHaptic();
    await AppHelpers.shareVerse(verse);

    // تسجيل إنجاز المشاركة
    if (context.mounted) {
      context.read<AchievementsProvider>().recordShare();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
      return TextButton.icon(
        onPressed: () => _shareVerse(context),
        icon: Icon(Icons.share, size: size),
        label: const Text(AppConstants.share),
      );
    }

    return IconButton(
      onPressed: () => _shareVerse(context),
      icon: const Icon(Icons.share),
      iconSize: size,
      tooltip: AppConstants.share,
    );
  }
}

/// زر النسخ
class CopyButton extends StatelessWidget {
  final VerseModel verse;
  final double size;
  final bool showLabel;

  const CopyButton({
    super.key,
    required this.verse,
    this.size = 24.0,
    this.showLabel = false,
  });

  Future<void> _copyVerse(BuildContext context) async {
    await AppHelpers.copyToClipboard(verse.getFormattedText(), context);
  }

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
      return TextButton.icon(
        onPressed: () => _copyVerse(context),
        icon: Icon(Icons.copy, size: size),
        label: const Text(AppConstants.copy),
      );
    }

    return IconButton(
      onPressed: () => _copyVerse(context),
      icon: const Icon(Icons.copy),
      iconSize: size,
      tooltip: AppConstants.copy,
    );
  }
}
