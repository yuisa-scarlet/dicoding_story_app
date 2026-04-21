class SelectedLocation {
  const SelectedLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.hasAddressLookupError = false,
  });

  final double latitude;
  final double longitude;
  final String? address;
  final bool hasAddressLookupError;

  String get coordinateLabel =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}
