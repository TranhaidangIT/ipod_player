import 'package:flutter/services.dart';

class AudioFeedback {
  static Future<void> init() async {
    // Native HapticFeedback is safe to call on all devices without manual checks
  }

  static void playClick() {
    // Native light impact haptic feedback
    HapticFeedback.lightImpact();
    
    // Native system click sound
    SystemSound.play(SystemSoundType.click);
  }

  static void playScroll() {
    // Native selection click haptic feedback (very fast/subtle)
    HapticFeedback.selectionClick();
  }
}
