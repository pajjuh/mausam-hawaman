import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../widgets/widget_service.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (kDebugMode) {
        print("Background Task '$task' triggered.");
      }

      // Initialize the ProviderContainer to use our existing architecture in the background
      final container = ProviderContainer();
      
      // We must await initialization if needed, but Riverpod providers usually load lazily
      final db = container.read(databaseProvider);
      final weatherRepo = container.read(weatherRepositoryProvider);
      
      // Initialize NotificationService
      final notificationService = NotificationService();
      await notificationService.init();

      // 1. Get default location from database
      final locations = await db.getAllLocations();
      if (locations.isEmpty) return true; // No location to check

      // Assume first location is default for now (or find where is_default == true)
      final defaultLocation = locations.firstWhere((l) => l.isDefault, orElse: () => locations.first);

      // 2. Fetch weather (this will hit the API if cache is old)
      final weather = await weatherRepo.getWeather(
        latitude: defaultLocation.lat,
        longitude: defaultLocation.lng,
        locationId: defaultLocation.id,
      );

      // 3. Check for high rain probability in the next 3 hours
      bool rainIncoming = false;
      int maxProb = 0;
      
      for (int i = 0; i < 3 && i < weather.hourly.length; i++) {
        if (weather.hourly[i].precipitationProbability > 60) {
          rainIncoming = true;
          if (weather.hourly[i].precipitationProbability > maxProb) {
            maxProb = weather.hourly[i].precipitationProbability;
          }
        }
      }

      // 4. Trigger alert
      if (rainIncoming) {
        await notificationService.showRainAlert(
          'Rain Alert!',
          'High chance ($maxProb%) of rain in the next few hours in ${defaultLocation.name}.',
        );
      }
      
      // 5. Update Home Widget
      await WidgetService.updateHomeWidget(
        location: defaultLocation.name,
        temp: weather.current.temperature.round().toString(),
        rain: weather.hourly.isNotEmpty ? weather.hourly.first.precipitationProbability.toString() : '0',
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Background Task Error: $e");
      }
      return false; // Tells WorkManager to retry later
    }
  });
}
