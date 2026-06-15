/// Represents a saved or detected location
class LocationData {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final String? district;
  final String? state;

  const LocationData({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    this.district,
    this.state,
  });

  /// Full display name: "Village, District, State"
  String get displayName {
    final parts = <String>[name];
    if (district != null && district!.isNotEmpty && district != name) {
      parts.add(district!);
    }
    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }
    return parts.join(', ');
  }

  /// Short display: "Village, District"
  String get shortDisplayName {
    if (district != null && district!.isNotEmpty && district != name) {
      return '$name, $district';
    }
    return name;
  }

  LocationData copyWith({
    int? id,
    String? name,
    double? latitude,
    double? longitude,
    bool? isDefault,
    String? district,
    String? state,
  }) {
    return LocationData(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
      district: district ?? this.district,
      state: state ?? this.state,
    );
  }

  factory LocationData.fromNominatim(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final displayName = json['display_name'] as String? ?? '';

    // Extract the most specific name
    final name = address['village'] ??
        address['town'] ??
        address['city'] ??
        address['suburb'] ??
        displayName.split(',').first.trim();

    return LocationData(
      name: name,
      latitude: double.parse(json['lat'].toString()),
      longitude: double.parse(json['lon'].toString()),
      district: address['county'] ?? address['state_district'],
      state: address['state'],
    );
  }

  factory LocationData.fromSearchResult(Map<String, dynamic> json) {
    final displayName = json['display_name'] as String? ?? '';
    final parts = displayName.split(',').map((e) => e.trim()).toList();

    return LocationData(
      name: parts.isNotEmpty ? parts.first : 'Unknown',
      latitude: double.parse(json['lat'].toString()),
      longitude: double.parse(json['lon'].toString()),
      district: parts.length > 1 ? parts[1] : null,
      state: parts.length > 2 ? parts[2] : null,
    );
  }

  @override
  String toString() => 'LocationData($name, $latitude, $longitude)';
}
