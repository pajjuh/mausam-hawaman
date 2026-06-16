import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/providers.dart';
import 'widgets/spray_window_card.dart';
import 'widgets/soil_moisture_card.dart';
import 'widgets/crop_conditions_card.dart';

/// Main screen for Farming Mode features (F8, F9, F10)
class FarmingScreen extends ConsumerWidget {
  const FarmingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);
    final weatherAsync = ref.watch(weatherProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Farming Mode',
          style: AppTextStyles.displaySmall.copyWith(color: AppColors.success),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.success,
          onRefresh: () async {
            await ref.read(weatherRefreshProvider)();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    locationAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error: $err')),
                      data: (location) {
                        return weatherAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, _) => Center(child: Text('Error loading weather: $err')),
                          data: (weather) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  location.shortDisplayName,
                                  style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  softWrap: true,
                                ),
                                const SizedBox(height: 12),
                                // ── Experimental Warning Banner ──
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.warningLight.withOpacity(0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.science_rounded,
                                        color: AppColors.warning,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Experimental Feature',
                                              style: AppTextStyles.labelMedium.copyWith(
                                                color: AppColors.warning,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Farming data has not been independently verified. Use this section as a general guide only — not as professional agricultural advice.',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.warning.withOpacity(0.85),
                                                height: 1.4,
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SprayWindowCard(forecasts: weather.hourly),
                                const SizedBox(height: 24),
                                SoilMoistureCard(daily: weather.daily.isNotEmpty ? weather.daily.first : null),
                                const SizedBox(height: 24),
                                CropConditionsCard(currentWeather: weather.current),
                                const SizedBox(height: 32),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
