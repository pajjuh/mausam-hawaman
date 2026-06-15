import 'dart:convert';
import 'dart:io';

void main() async {
  final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=28.6&longitude=77.2&hourly=temperature_2m,precipitation_probability&models=best_match,gfs_seamless');
  final request = await HttpClient().getUrl(url);
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  final json = jsonDecode(responseBody) as Map<String, dynamic>;
  final hourly = json['hourly'] as Map<String, dynamic>;
  print('Hourly keys: ${hourly.keys.toList()}');
}
