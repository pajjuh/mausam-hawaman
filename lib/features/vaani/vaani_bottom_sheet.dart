import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../providers/settings_provider.dart';
import 'vaani_icon.dart';
import 'vaani_service.dart';
import 'vaani_script_builder.dart';
import 'vaani_waveform.dart';

/// Modal bottom sheet for the Vaani voice weather feature.
/// Shows language selection chips → transforms into waveform during speech.
class VaaniBottomSheet extends ConsumerStatefulWidget {
  const VaaniBottomSheet({super.key});

  @override
  ConsumerState<VaaniBottomSheet> createState() => _VaaniBottomSheetState();
}

class _VaaniBottomSheetState extends ConsumerState<VaaniBottomSheet> {
  final _vaani = VaaniService.instance;
  String? _speakingLanguage; // null = selection mode

  @override
  void initState() {
    super.initState();
    _vaani.state.addListener(_onVaaniStateChanged);
    
    // Auto-start speaking using default language from settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      _onLanguageSelected(settings.vaaniLang);
    });
  }

  @override
  void dispose() {
    _vaani.state.removeListener(_onVaaniStateChanged);
    // Stop speech if user dismisses the sheet while speaking
    if (_vaani.state.value == VaaniState.speaking) {
      _vaani.stop();
    }
    super.dispose();
  }

  void _onVaaniStateChanged() {
    if (!mounted) return;
    // When TTS finishes speaking, close the bottom sheet
    if (_vaani.state.value == VaaniState.idle && _speakingLanguage != null) {
      _speakingLanguage = null;
      Navigator.of(context).pop();
    }
  }

  Future<void> _onLanguageSelected(String langCode) async {
    // Get current weather data from providers (already cached)
    final locationAsync = ref.read(currentLocationProvider);
    final weatherAsync = ref.read(weatherProvider);

    final location = locationAsync.valueOrNull;
    final weather = weatherAsync.valueOrNull;

    if (location == null || weather == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Weather data not available. Please refresh first.',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // Check if we need to show the language pack dialog for kn-IN or mr-IN
    final shouldProceed = await _checkLanguagePack(langCode);
    if (!shouldProceed) return;

    final settings = ref.read(settingsProvider);

    // Build the voice script
    final script = VaaniScriptBuilder.buildScript(
      langCode: langCode,
      location: location,
      current: weather.current,
      hourly: weather.hourly,
      tempUnit: settings.tempUnit,
      windUnit: settings.windUnit,
    );

    // Transition to speaking mode
    setState(() => _speakingLanguage = langCode);

    // Attempt to speak
    final success = await _vaani.speak(script, langCode);
    if (!success && mounted) {
      // Language not installed — show helpful snackbar
      final langName = VaaniService.supportedLanguages[langCode] ?? langCode;
      setState(() => _speakingLanguage = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please install $langName voice from your phone\'s Text-to-Speech settings',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
            ),
            backgroundColor: AppColors.warning,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _onStop() async {
    await _vaani.stop();
    if (mounted && _speakingLanguage != null) {
      _speakingLanguage = null;
      Navigator.of(context).pop();
    }
  }

  Future<bool> _checkLanguagePack(String langCode) async {
    if (langCode != 'kn-IN' && langCode != 'mr-IN') return true;

    final prefs = await SharedPreferences.getInstance();
    final key = 'vaani_voice_dialog_shown_$langCode';
    final hasShown = prefs.getBool(key) ?? false;

    if (hasShown) return true;

    if (!mounted) return false;

    final langName = langCode == 'kn-IN' ? 'Kannada' : 'Marathi';

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Better Voice Available',
            style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'For natural sounding $langName voice, download the language pack from your phone\'s Text-to-Speech settings. This is free and only needs to be done once.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('continue');
              },
              child: const Text('Continue Anyway'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop('download');
              },
              child: const Text('Download Voice'),
            ),
          ],
        );
      },
    );

    // Only store that we showed it
    await prefs.setBool(key, true);

    if (result == 'download') {
      const intent = AndroidIntent(
        action: 'com.android.settings.TTS_SETTINGS',
      );
      intent.launch();
      // Wait for user to return, dismiss this bottom sheet maybe? Or keep it open.
      // Usually keeping it open is fine, but they won't hear anything. Let's return false to not speak.
      return false;
    }

    // If dismissed or 'continue', we proceed to speak.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag Handle ──
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Close Button ──
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // ── Content (animated transition between modes) ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _speakingLanguage != null
                ? _buildSpeakingMode()
                : _buildLoadingMode(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMode(bool isDark) {
    return Column(
      key: const ValueKey('loading'),
      mainAxisSize: MainAxisSize.min,
      children: [
        VaaniIcon(color: AppColors.primary, size: 48),
        const SizedBox(height: 12),
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
      ],
    );
  }

  // Language chips removed as language is now managed in Settings

  /// Speaking mode — waveform + stop button
  Widget _buildSpeakingMode() {
    final langName =
        VaaniService.supportedLanguages[_speakingLanguage] ?? 'Unknown';

    return Column(
      key: const ValueKey('speaking'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),

        // ── Animated Waveform ──
        const VaaniWaveform(),
        const SizedBox(height: 20),

        // ── "Speaking in Hindi..." label ──
        Text(
          'Speaking in $langName...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),

        // ── Stop Button ──
        OutlinedButton.icon(
          onPressed: _onStop,
          icon: const Icon(Icons.stop_rounded, size: 20),
          label: const Text('Stop'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: const BorderSide(color: AppColors.dangerLight),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

