import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/settings_provider.dart';

import 'package:android_intent_plus/android_intent.dart';

// ─── Constants ───────────────────────────────────────────────────────────────
const _kPrimary = Color(0xFF1A56DB);
const _kSuccess = Color(0xFF065F46);
const _kWarning = Color(0xFF92400E);
const _kDanger = Color(0xFF991B1B);
const _kRadius = 16.0;

// ─── Settings Page ────────────────────────────────────────────────────────────
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  // ── helpers ─────────────────────────────────────────────────────────────────

  Widget _sectionHeader(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 16, endIndent: 16);

  // Segmented toggle row — used for temp/wind unit
  Widget _segmentedRow(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> labels,
    required List<String> values,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                        ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Segmented control
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(values.length, (i) {
                final isSelected = selected == values[i];
                return GestureDetector(
                  onTap: () => onChanged(values[i]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected ? _kPrimary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Language picker tile — opens bottom sheet
  Widget _vaaniLanguageTile(BuildContext context, WidgetRef ref, String currentLang) {
    final langLabels = {
      'en-IN': 'English',
      'hi-IN': 'हिन्दी',
      'kn-IN': 'ಕನ್ನಡ',
      'mr-IN': 'मराठी',
    };

    return ListTile(
      leading: const Icon(Icons.record_voice_over_rounded, color: _kPrimary),
      title: const Text(
        'Vaani Language',
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
      subtitle: Text(
        langLabels[currentLang] ?? 'English',
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55)),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showLanguagePicker(context, ref, langLabels, currentLang),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, Map<String, String> langLabels, String currentLang) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(_kRadius)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Select Vaani Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 8),
              ...langLabels.entries.map((e) {
                final isSelected = currentLang == e.key;
                return ListTile(
                  leading: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: _kPrimary)
                      : const Icon(Icons.radio_button_unchecked_rounded),
                  title: Text(
                    e.value,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  onTap: () {
                    ref.read(settingsProvider.notifier).setVaaniLang(e.key);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Switch tile
  Widget _switchTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? iconColor,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: iconColor ?? _kPrimary),
      title: Text(title, overflow: TextOverflow.ellipsis, softWrap: true),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55)),
      ),
      value: value,
      activeColor: _kPrimary,
      onChanged: onChanged,
    );
  }

  // Tap tile (for navigation)
  Widget _navTile(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? _kPrimary),
      title: Text(title, overflow: TextOverflow.ellipsis, softWrap: true),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55)),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }

  // ── build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        children: [

          // ── VAANI ──────────────────────────────────────────────────────────
          _sectionHeader(context, 'Vaani'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
            elevation: 0,
            child: Column(
              children: [
                _vaaniLanguageTile(context, ref, settings.vaaniLang),
              ],
            ),
          ),

          // ── UNITS ──────────────────────────────────────────────────────────
          _sectionHeader(context, 'Units'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
            elevation: 0,
            child: Column(
              children: [
                _segmentedRow(
                  context,
                  icon: Icons.thermostat_rounded,
                  title: 'Temperature',
                  subtitle: 'Display unit for temperature',
                  labels: const ['°C', '°F'],
                  values: const ['C', 'F'],
                  selected: settings.tempUnit,
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setTempUnit(v);
                  },
                ),
                _divider(),
                _segmentedRow(
                  context,
                  icon: Icons.air_rounded,
                  title: 'Wind Speed',
                  subtitle: 'Display unit for wind',
                  labels: const ['km/h', 'm/s'],
                  values: const ['kmh', 'ms'],
                  selected: settings.windUnit,
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setWindUnit(v);
                  },
                ),
              ],
            ),
          ),

          // ── LOCATIONS ─────────────────────────────────────────────────────
          _sectionHeader(context, 'Locations'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
            elevation: 0,
            child: Column(
              children: [
                _navTile(
                  context,
                  icon: Icons.location_on_rounded,
                  title: 'Manage Locations',
                  subtitle: 'Add, remove or set default location',
                  onTap: () {
                    // TODO: navigate to location management screen
                    // context.push('/locations');
                  },
                ),
              ],
            ),
          ),

          // ── NOTIFICATIONS ─────────────────────────────────────────────────
          _sectionHeader(context, 'Notifications'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
            elevation: 0,
            child: Column(
              children: [
                _switchTile(
                  context,
                  icon: Icons.water_drop_rounded,
                  title: 'Rain Alerts',
                  subtitle: 'Notify when rain is likely in next 3 hours',
                  value: settings.rainAlert,
                  iconColor: const Color(0xFF1A56DB),
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setRainAlert(v);
                  },
                ),
              ],
            ),
          ),

          // ── ABOUT ─────────────────────────────────────────────────────────
          _sectionHeader(context, 'About'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kRadius)),
            elevation: 0,
            child: Column(
              children: [
                _navTile(
                  context,
                  icon: Icons.code_rounded,
                  title: 'GitHub',
                  subtitle: 'pajjuh/mausam-hawaman',
                  onTap: () {
                    const intent = AndroidIntent(
                      action: 'action_view',
                      data: 'https://github.com/pajjuh/mausam-hawaman',
                    );
                    intent.launch();
                  },
                ),
                _divider(),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded, color: _kPrimary),
                  title: const Text('Version', overflow: TextOverflow.ellipsis, softWrap: true),
                  trailing: Text(
                    'v1.0.0', // TODO: replace with packageInfo.version
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _divider(),
                ListTile(
                  leading: const Icon(Icons.favorite_rounded, color: _kDanger),
                  title: const Text('Made for India', overflow: TextOverflow.ellipsis, softWrap: true),
                  subtitle: const Text(
                    'Free forever · No ads · No data selling',
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

