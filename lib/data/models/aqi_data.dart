class AqiData {
  final int aqi;
  final double pm10;
  final double pm25;
  final double uvIndex;
  final DateTime time;

  const AqiData({
    required this.aqi,
    required this.pm10,
    required this.pm25,
    required this.uvIndex,
    required this.time,
  });

  factory AqiData.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    return AqiData(
      aqi: (current['us_aqi'] as num?)?.toInt() ?? 0,
      pm10: (current['pm10'] as num?)?.toDouble() ?? 0,
      pm25: (current['pm2_5'] as num?)?.toDouble() ?? 0,
      uvIndex: (current['uv_index'] as num?)?.toDouble() ?? 0,
      time: DateTime.tryParse(current['time']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
