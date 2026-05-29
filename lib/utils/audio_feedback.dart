import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class AudioFeedback {
  static bool _canVibrate = false;

  static Future<void> init() async {
    try {
      _canVibrate = await Vibrate.canVibrate;
    } catch (e) {
      _canVibrate = false;
    }
  }

  static void playClick() {
    // Haptic feedback
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.light);
    }
    // Native system click sound
    SystemSound.play(SystemSoundType.click);
  }

  static void playScroll() {
    if (_canVibrate) {
      Vibrate.feedback(FeedbackType.selection);
    }
  }
}
