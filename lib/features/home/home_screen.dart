import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/providers.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/hourly_forecast_strip.dart';
import 'widgets/daily_forecast_card.dart';
import 'widgets/update_banner.dart';
import '../aqi/widgets/aqi_card.dart';
import '../radar/widgets/radar_map_card.dart';

/// Main home screen assembling all weather widgets (F2, F3, F4, F13)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);
    final weatherAsync = ref.watch(weatherProvider);
    final updateAvailable = ref.watch(updateAvailableProvider);
    final versionCheck = ref.watch(versionCheckProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ref.read(weatherRefreshProvider)();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── App Bar ──
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppColors.background,
                surfaceTintColor: Colors.transparent,
                title: Row(
                  children: [
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search_rounded),
                    color: AppColors.textSecondary,
                    tooltip: 'Search location',
                    onPressed: () => context.push('/search'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location_rounded),
                    color: AppColors.textSecondary,
                    tooltip: 'Detect location',
                    onPressed: () {
                      ref
                          .read(currentLocationProvider.notifier)
                          .detectLocation();
                    },
                  ),
                ],
              ),

              // ── Body ──
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Update banner (F13)
                    if (updateAvailable)
                      UpdateBanner(
                        latestVersion: versionCheck.valueOrNull?.tagName ?? '',
                        releaseUrl: versionCheck.valueOrNull?.htmlUrl,
                      ),

                    const SizedBox(height: 8),

                    // Main content
                    locationAsync.when(
                      loading: () => const _LoadingState(),
                      error: (error, _) => _ErrorState(
                        message: error.toString(),
                        onRetry: () {
                          ref
                              .read(currentLocationProvider.notifier)
                              .detectLocation();
                        },
                      ),
                      data: (location) {
                        return weatherAsync.when(
                          loading: () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show location while weather loads
                              _LocationHeader(name: location.shortDisplayName),
                              const SizedBox(height: 16),
                              const _LoadingState(),
                            ],
                          ),
                          error: (error, _) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _LocationHeader(name: location.shortDisplayName),
                              const SizedBox(height: 16),
                              _ErrorState(
                                message: error.toString(),
                                onRetry: () => ref.invalidate(weatherProvider),
                              ),
                            ],
                          ),
                          data: (weather) {
                            final todayForecast = weather.daily.isNotEmpty
                                ? weather.daily.first
                                : null;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // F2: Current Weather
                                CurrentWeatherCard(
                                  weather: weather.current,
                                  location: location,
                                  todayForecast: todayForecast,
                                ),
                                const SizedBox(height: 24),

                                // F7: Air Quality
                                const AqiCard(),
                                const SizedBox(height: 24),

                                // F3: Hourly Forecast
                                HourlyForecastStrip(
                                    forecasts: weather.hourly),
                                const SizedBox(height: 24),

                                // F6: Rain Radar
                                const RadarMapCard(),
                                const SizedBox(height: 24),

                                // F4: Daily Forecast
                                DailyForecastCard(
                                    forecasts: weather.daily),
                                const SizedBox(height: 32),

                                // Sunrise/Sunset info
                                if (todayForecast?.sunrise != null &&
                                    todayForecast?.sunset != null)
                                  _SunriseSunsetRow(
                                    sunrise: todayForecast!.sunrise!,
                                    sunset: todayForecast.sunset!,
                                  ),
                                const SizedBox(height: 24),
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

// ── Helper Widgets ──

class _LocationHeader extends StatelessWidget {
  final String name;
  const _LocationHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on_rounded,
            size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            name,
            style: AppTextStyles.bodyMedium,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Loading weather data...',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded,
                  size: 48, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: AppTextStyles.displaySmall,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SunriseSunsetRow extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const _SunriseSunsetRow({required this.sunrise, required this.sunset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wb_twilight_rounded,
                    size: 20, color: Color(0xFFF97316)),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      'Sunrise',
                      style: AppTextStyles.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Text(
                      '${sunrise.hour}:${sunrise.minute.toString().padLeft(2, '0')} AM',
                      style: AppTextStyles.labelLarge,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.nights_stay_rounded,
                    size: 20, color: Color(0xFF6366F1)),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      'Sunset',
                      style: AppTextStyles.labelSmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Text(
                      '${sunset.hour > 12 ? sunset.hour - 12 : sunset.hour}:${sunset.minute.toString().padLeft(2, '0')} PM',
                      style: AppTextStyles.labelLarge,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
