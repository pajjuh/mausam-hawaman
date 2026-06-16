import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/providers.dart';
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
    // When TTS finishes speaking, go back to selection mode
    if (_vaani.state.value == VaaniState.idle && _speakingLanguage != null) {
      setState(() => _speakingLanguage = null);
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

    // Build the voice script
    final script = VaaniScriptBuilder.buildScript(
      langCode: langCode,
      location: location,
      current: weather.current,
      hourly: weather.hourly,
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
    setState(() => _speakingLanguage = null);
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
                : _buildSelectionMode(isDark),
          ),
        ],
      ),
    );
  }

  /// Selection mode — icon, title, subtitle, language chips
  Widget _buildSelectionMode(bool isDark) {
    return Column(
      key: const ValueKey('selection'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Vaani Icon ──
        VaaniIcon(
          color: AppColors.primary,
          size: 48,
        ),
        const SizedBox(height: 12),

        // ── Title: "Vaani" in Mukta bold ──
        Text(
          'Vaani',
          style: GoogleFonts.mukta(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),

        // ── Subtitle ──
        Text(
          'Apne mausam ki jankari suniye — bina padhe',
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),

        // ── Language Chips ──
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: VaaniService.supportedLanguages.entries.map((entry) {
            return _LanguageChip(
              langCode: entry.key,
              label: entry.value,
              onTap: () => _onLanguageSelected(entry.key),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

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

/// Individual language selection chip
class _LanguageChip extends StatelessWidget {
  final String langCode;
  final String label;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.langCode,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
