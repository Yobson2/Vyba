# Flutter-specific ProGuard rules for release builds.
#
# Reference: https://flutter.dev/to/obfuscate

# Keep Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep Gson (if used for JSON serialization)
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep model classes (adjust package path for your app)
-keep class com.example.flutter_templates.** { *; }
