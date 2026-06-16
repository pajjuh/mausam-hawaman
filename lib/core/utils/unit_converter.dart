class UnitConverter {
  UnitConverter._();

  /// Converts Celsius to Fahrenheit if unit is 'F', otherwise returns Celsius rounded.
  static int convertTemp(double celsius, String unit) {
    if (unit == 'F') {
      return ((celsius * 9 / 5) + 32).round();
    }
    return celsius.round();
  }

  /// Converts km/h to m/s if unit is 'ms', otherwise returns km/h rounded.
  static int convertWindSpeed(double kmh, String unit) {
    if (unit == 'ms') {
      return (kmh * (5 / 18)).round();
    }
    return kmh.round();
  }
}
