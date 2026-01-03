# ML Kit Text Recognition language-specific classes
-keep class com.google.mlkit.vision.text.** { *; }
-keepclassmembers class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Keep ML Kit commons
-keep class com.google.mlkit.** { *; }
-keepclassmembers class com.google.mlkit.** { *; }
