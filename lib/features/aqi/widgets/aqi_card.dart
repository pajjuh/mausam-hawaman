import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';

class AqiCard extends ConsumerWidget {
  const AqiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiAsync = ref.watch(aqiProvider);

    return aqiAsync.when(
      data: (data) {
        final Color aqiColor;
        final String aqiLabel;
        if (data.aqi <= 50) {
          aqiColor = AppColors.success;
          aqiLabel = 'Good';
        } else if (data.aqi <= 100) {
          aqiColor = Colors.yellow.shade700;
          aqiLabel = 'Moderate';
        } else if (data.aqi <= 150) {
          aqiColor = AppColors.warning;
          aqiLabel = 'Unhealthy for Sensitive Groups';
        } else if (data.aqi <= 200) {
          aqiColor = AppColors.danger;
          aqiLabel = 'Unhealthy';
        } else if (data.aqi <= 300) {
          aqiColor = Colors.purple;
          aqiLabel = 'Very Unhealthy';
        } else {
          aqiColor = Colors.brown;
          aqiLabel = 'Hazardous';
        }

        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Air Quality',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: aqiColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: aqiColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'US AQI ${data.aqi}',
                        style: TextStyle(
                          color: aqiColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  aqiLabel,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: aqiColor,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStat(context, 'PM2.5', '${data.pm25} µg/m³'),
                    _buildStat(context, 'PM10', '${data.pm10} µg/m³'),
                    _buildStat(context, 'UV Index', data.uvIndex.toString()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      )),
      error: (e, st) => const SizedBox.shrink(),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ],
    );
  }
}
