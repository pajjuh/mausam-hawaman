import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/providers.dart';

class RadarMapCard extends ConsumerWidget {
  const RadarMapCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(currentLocationProvider);
    final radarPathAsync = ref.watch(radarPathProvider);

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
            Text(
              'Live Rain Radar',
              style: AppTextStyles.displaySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 250,
                child: locationAsync.when(
                  data: (location) {
                    return FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(location.latitude, location.longitude),
                        initialZoom: 6.0,
                        minZoom: 3.0,
                        maxZoom: 7.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.mausam.hawaman',
                        ),
                        radarPathAsync.when(
                          data: (path) {
                            if (path == null) return const SizedBox.shrink();
                            return Opacity(
                              opacity: 0.6,
                              child: TileLayer(
                                urlTemplate: 'https://tilecache.rainviewer.com$path/256/{z}/{x}/{y}/2/1_1.png',
                              ),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(location.latitude, location.longitude),
                              width: 40,
                              height: 40,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => const Center(child: Text('Could not load map')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
