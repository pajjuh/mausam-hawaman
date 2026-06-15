import 'package:home_widget/home_widget.dart';

class WidgetService {
  static Future<void> updateHomeWidget({
    required String location,
    required String temp,
    required String rain,
  }) async {
    await HomeWidget.saveWidgetData<String>('location', location);
    await HomeWidget.saveWidgetData<String>('temp', '$temp°C');
    await HomeWidget.saveWidgetData<String>('rain', 'Rain: $rain%');
    await HomeWidget.updateWidget(
      name: 'MausamWidgetProvider',
      iOSName: 'MausamWidgetProvider',
    );
  }
}
