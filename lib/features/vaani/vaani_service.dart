import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// State of the Vaani TTS engine
enum VaaniState { idle, speaking, error }

/// Singleton wrapper around FlutterTts for the Vaani voice feature.
/// Manages TTS lifecycle, language switching, and state notifications.
class VaaniService {
  VaaniService._internal();
  static final VaaniService _instance = VaaniService._internal();
  static VaaniService get instance => _instance;

  FlutterTts? _tts;
  bool _initialized = false;

  /// Observable state — UI widgets listen to this
  final ValueNotifier<VaaniState> state = ValueNotifier(VaaniState.idle);

  /// Currently selected language code (e.g., 'hi-IN')
  String? currentLanguage;

  /// Supported language codes
  static const Map<String, String> supportedLanguages = {
    'kn-IN': 'ಕನ್ನಡ',
    'hi-IN': 'हिन्दी',
    'mr-IN': 'मराठी',
    'en-IN': 'English',
  };

  /// Initialize TTS engine with Vaani-specific settings
  Future<void> init() async {
    if (_initialized) return;

    _tts = FlutterTts();

    // Vaani-specific TTS settings
    await _tts!.setSpeechRate(0.45); // Slightly slower for rural users
    await _tts!.setPitch(1.0);
    await _tts!.setVolume(1.0);

    // Wire up completion/error handlers
    _tts!.setCompletionHandler(() {
      state.value = VaaniState.idle;
    });

    _tts!.setErrorHandler((msg) {
      debugPrint('Vaani TTS error: $msg');
      state.value = VaaniState.error;
      // Auto-recover to idle after a brief moment
      Future.delayed(const Duration(seconds: 2), () {
        if (state.value == VaaniState.error) {
          state.value = VaaniState.idle;
        }
      });
    });

    _tts!.setCancelHandler(() {
      state.value = VaaniState.idle;
    });

    _initialized = true;
  }

  /// Check if a language TTS engine is installed on the device
  Future<bool> isLanguageAvailable(String langCode) async {
    await init();
    final result = await _tts!.isLanguageAvailable(langCode);
    return result == true || result == 1;
  }

  /// Speak the given text in the specified language.
  /// Returns `true` if speech started successfully, `false` if language unavailable.
  Future<bool> speak(String text, String langCode) async {
    await init();

    // Pre-check language availability
    final available = await isLanguageAvailable(langCode);
    if (!available) {
      return false;
    }

    // Set language and speak
    await _tts!.setLanguage(langCode);
    currentLanguage = langCode;
    state.value = VaaniState.speaking;

    await _tts!.speak(text);
    return true;
  }

  /// Stop TTS immediately
  Future<void> stop() async {
    if (_tts != null) {
      await _tts!.stop();
      state.value = VaaniState.idle;
    }
  }

  /// Clean up resources
  void dispose() {
    _tts?.stop();
    state.dispose();
    _initialized = false;
    _tts = null;
  }
}
