import 'package:flutter/material.dart';

/// Design token colors from PRD v2.0
class AppColors {
  AppColors._();

  // ── Primary Palette ──
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // ── Semantic Colors ──
  static const Color success = Color(0xFF065F46);
  static const Color successLight = Color(0xFF10B981);
  static const Color successSurface = Color(0xFFECFDF5);

  static const Color warning = Color(0xFF92400E);
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningSurface = Color(0xFFFFFBEB);

  static const Color danger = Color(0xFF991B1B);
  static const Color dangerLight = Color(0xFFEF4444);
  static const Color dangerSurface = Color(0xFFFEF2F2);

  // ── Neutral Palette ──
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color surface = Color(0xFFF9FAFB);
  static const Color background = Color(0xFFF3F4F6);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // ── Weather-Specific Colors ──
  static const Color tempHot = Color(0xFFEF4444);
  static const Color tempWarm = Color(0xFFF97316);
  static const Color tempMild = Color(0xFFFBBF24);
  static const Color tempCool = Color(0xFF3B82F6);
  static const Color tempCold = Color(0xFF6366F1);

  static const Color rainLight = Color(0xFF60A5FA);
  static const Color rainMedium = Color(0xFF3B82F6);
  static const Color rainHeavy = Color(0xFF1D4ED8);

  // ── Confidence Badge Colors ──
  static const Color confidenceHigh = Color(0xFF065F46);
  static const Color confidenceMedium = Color(0xFF92400E);
  static const Color confidenceLow = Color(0xFF991B1B);

  // ── Gradient Presets ──
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A56DB), Color(0xFF60A5FA)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF97316), Color(0xFFEC4899)],
  );

  static const LinearGradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
  );
}
