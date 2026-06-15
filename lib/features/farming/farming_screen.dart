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
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
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
