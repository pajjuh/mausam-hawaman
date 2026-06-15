import 'dart:convert';
import 'dart:io';

void main() async {
  final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=28.6139&longitude=77.2090&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,wind_direction_10m,surface_pressure,visibility,is_day&hourly=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation_probability,precipitation,weather_code,wind_speed_10m,wind_gusts_10m,visibility,uv_index,is_day&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_sum,precipitation_probability_max,wind_speed_10m_max,sunrise,sunset,uv_index_max&timezone=auto&forecast_days=7&forecast_hours=48&wind_speed_unit=kmh&temperature_unit=celsius&models=best_match,gfs_seamless,icon_seamless,ecmwf_ifs04');
  
  try {
    final request = await HttpClient().getUrl(url);
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    
    if (json.containsKey('error')) {
      print('API ERROR: ${json['reason']}');
    } else {
      final hourly = json['hourly'] as Map<String, dynamic>? ?? {};
      final daily = json['daily'] as Map<String, dynamic>? ?? {};
      print('Hourly keys: ${hourly.keys.toList()}');
      print('Daily keys: ${daily.keys.toList()}');
    }
  } catch (e) {
    print('Exception: $e');
  }
}
