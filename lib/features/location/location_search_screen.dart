import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import '../../providers/providers.dart';

/// Location search screen with live Nominatim results (F1)
class LocationSearchScreen extends ConsumerStatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  ConsumerState<LocationSearchScreen> createState() =>
      _LocationSearchScreenState();
}

class _LocationSearchScreenState extends ConsumerState<LocationSearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);
    final savedLocations = ref.watch(savedLocationsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Search Location',
          style: AppTextStyles.displaySmall,
        ),
      ),
      body: Column(
        children: [
          // ── Search Input ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _onSearchChanged,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: 'City, village, or PIN code...',
                prefixIcon: Icon(Icons.search_rounded,
                    color: Theme.of(context).colorScheme.outline),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear_rounded,
                            color: Theme.of(context).colorScheme.outline),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchQueryProvider.notifier).state = '';
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Results ──
          Expanded(
            child: _searchController.text.trim().length >= 2
                ? _buildSearchResults(searchResults)
                : _buildSavedLocations(savedLocations),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue searchResults) {
    return searchResults.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (e, _) => Center(
        child: Text(
          'Search failed. Check your internet.',
          style: AppTextStyles.bodyMedium,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off_rounded,
                    size: 48, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 12),
                Text(
                  'No locations found',
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final location = results[index];
            return _locationTile(
              icon: Icons.location_on_outlined,
              title: location.name,
              subtitle: location.displayName,
              onTap: () async {
                final nav = GoRouter.of(context);
                await ref
                    .read(currentLocationProvider.notifier)
                    .selectSearchResult(location);
                nav.pop();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSavedLocations(AsyncValue savedLocations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Detect GPS Button ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () async {
              final nav = GoRouter.of(context);
              await ref
                  .read(currentLocationProvider.notifier)
                  .detectLocation();
              nav.pop();
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Flexible(
                    child: Icon(Icons.my_location_rounded,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use Current Location',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          'Detect via GPS',
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    child: Icon(Icons.chevron_right_rounded,
                        color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Saved Locations List ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Saved Locations',
            style: AppTextStyles.labelMedium,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        ),
        const SizedBox(height: 8),

        Expanded(
          child: savedLocations.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (locations) {
              if (locations.isEmpty) {
                return Center(
                  child: Text(
                    'No saved locations yet',
                    style: AppTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return _locationTile(
                    icon: location.isDefault
                        ? Icons.star_rounded
                        : Icons.location_on_outlined,
                    iconColor: location.isDefault
                        ? AppColors.warningLight
                        : Theme.of(context).colorScheme.outline,
                    title: location.name,
                    subtitle: location.displayName,
                    onTap: () {
                      ref
                          .read(currentLocationProvider.notifier)
                          .setLocation(location);
                      context.pop();
                    },
                    trailing: location.isDefault
                        ? null
                        : IconButton(
                            icon: Icon(Icons.delete_outline_rounded,
                                size: 20, color: Theme.of(context).colorScheme.outline),
                            onPressed: () async {
                              if (location.id != null) {
                                final repo = ref.read(
                                    locationRepositoryProvider);
                                await repo.deleteLocation(location.id!);
                                ref.invalidate(savedLocationsProvider);
                              }
                            },
                          ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _locationTile({
    required IconData icon,
    Color? iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Flexible(
              child: Icon(icon,
                  size: 22, color: iconColor ?? Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            if (trailing != null) Flexible(child: trailing),
          ],
        ),
      ),
    );
  }
}
