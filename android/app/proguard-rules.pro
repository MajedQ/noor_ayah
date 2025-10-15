# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep audio player classes
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audio_service.** { *; }

# Keep network classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }

# Keep audio related classes
-keep class android.media.** { *; }
-keep class androidx.media.** { *; }

# Keep SharedPreferences
-keep class android.content.SharedPreferences { *; }
-keep class android.content.SharedPreferences$** { *; }

# Keep Hive database
-keep class hive_flutter.** { *; }
-keep class **$HiveFieldAdapter { *; }

# Keep Google Play Core classes (for Flutter)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep all Flutter engine classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep all classes with @Keep annotation
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}
