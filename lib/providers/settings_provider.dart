import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyTempUnit = 'pref_temp_unit';       // 'C' or 'F'
const _keyWindUnit = 'pref_wind_unit';       // 'kmh' or 'ms'
const _keyVaaniLang = 'pref_vaani_lang';     // 'en-IN' | 'hi-IN' | 'kn-IN' | 'mr-IN'
const _keyRainAlert = 'pref_rain_alert';     // bool

class SettingsState {
  final String tempUnit;
  final String windUnit;
  final String vaaniLang;
  final bool rainAlert;

  const SettingsState({
    required this.tempUnit,
    required this.windUnit,
    required this.vaaniLang,
    required this.rainAlert,
  });

  SettingsState copyWith({
    String? tempUnit,
    String? windUnit,
    String? vaaniLang,
    bool? rainAlert,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      windUnit: windUnit ?? this.windUnit,
      vaaniLang: vaaniLang ?? this.vaaniLang,
      rainAlert: rainAlert ?? this.rainAlert,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState(
    tempUnit: 'C',
    windUnit: 'kmh',
    vaaniLang: 'en-IN',
    rainAlert: true,
  )) {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      tempUnit: prefs.getString(_keyTempUnit) ?? 'C',
      windUnit: prefs.getString(_keyWindUnit) ?? 'kmh',
      vaaniLang: prefs.getString(_keyVaaniLang) ?? 'en-IN',
      rainAlert: prefs.getBool(_keyRainAlert) ?? true,
    );
  }

  Future<void> setTempUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTempUnit, unit);
    state = state.copyWith(tempUnit: unit);
  }

  Future<void> setWindUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWindUnit, unit);
    state = state.copyWith(windUnit: unit);
  }

  Future<void> setVaaniLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyVaaniLang, lang);
    state = state.copyWith(vaaniLang: lang);
  }

  Future<void> setRainAlert(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRainAlert, value);
    state = state.copyWith(rainAlert: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
