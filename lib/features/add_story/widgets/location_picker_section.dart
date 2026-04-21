import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/config.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/services/reverse_geocoding_service.dart';
import '../../../shared/theme/app_color.dart';
import '../../../shared/widgets/app_snack_bar.dart';
import '../model/selected_location.dart';
import '../providers/add_story_provider.dart';

class LocationPickerSection extends StatefulWidget {
  const LocationPickerSection({super.key, required this.isLoading});

  final bool isLoading;

  @override
  State<LocationPickerSection> createState() => _LocationPickerSectionState();
}

class _LocationPickerSectionState extends State<LocationPickerSection> {
  static const _defaultTarget = LatLng(-6.200000, 106.816666);
  final ReverseGeocodingService _geocodingService = ReverseGeocodingService();

  Marker? _marker;
  bool _isResolvingAddress = false;
  bool _isFetchingLocation = false;
  GoogleMapController? _mapController;

  Future<void> _useCurrentLocation(AddStoryProvider provider) async {
    final strings = context.strings;

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      AppSnackBar.error(context, strings.locationServiceDisabled);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        AppSnackBar.error(context, strings.locationPermissionDenied);
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      AppSnackBar.error(context, strings.locationPermissionPermanentlyDenied);
      return;
    }

    setState(() => _isFetchingLocation = true);
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final point = LatLng(position.latitude, position.longitude);
      await _onMapTapped(provider, point);
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(point, 15),
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackBar.error(context, strings.locationPermissionDenied);
    } finally {
      if (mounted) setState(() => _isFetchingLocation = false);
    }
  }

  Future<void> _onMapTapped(AddStoryProvider provider, LatLng point) async {
    setState(() => _isResolvingAddress = true);

    String? address;
    try {
      address = await _geocodingService.getAddress(
        point.latitude,
        point.longitude,
      );
    } catch (_) {
      address = null;
    }

    final selected = SelectedLocation(
      latitude: point.latitude,
      longitude: point.longitude,
      address: address,
      hasAddressLookupError: address == null,
    );
    provider.setSelectedLocation(selected);

    if (!mounted) return;

    final strings = context.strings;
    final marker = Marker(
      markerId: const MarkerId('selected-location'),
      position: point,
      infoWindow: InfoWindow(
        title: strings.selectedLocationTitle,
        snippet: address ?? strings.addressLookupFailed,
      ),
      onTap: () {
        final info =
            address ??
            strings.addressLookupFailedWithCoord(selected.coordinateLabel);
        AppSnackBar.success(context, info);
      },
    );

    setState(() {
      _marker = marker;
      _isResolvingAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Consumer<AddStoryProvider>(
      builder: (context, provider, _) {
        final selected = provider.selectedLocation;
        final hasSelected = selected != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.pickLocation,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.textDark,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: AppConfig.isTest
                    ? Container(
                        color: const Color(0xFFF3F4F6),
                        alignment: Alignment.center,
                        child: Text(
                          strings.mapPreviewPlaceholder,
                          key: const Key('map-picker-placeholder'),
                        ),
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: hasSelected
                              ? LatLng(selected.latitude, selected.longitude)
                              : _defaultTarget,
                          zoom: hasSelected ? 14 : 5,
                        ),
                        markers: {if (_marker != null) _marker!},
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                        onTap: widget.isLoading
                            ? null
                            : (point) => _onMapTapped(provider, point),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.isLoading || _isFetchingLocation || _isResolvingAddress
                    ? null
                    : () => _useCurrentLocation(provider),
                icon: _isFetchingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location, size: 18),
                label: Text(
                  _isFetchingLocation
                      ? strings.fetchingLocation
                      : strings.useCurrentLocation,
                ),
              ),
            ),
            if (_isResolvingAddress)
              Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    strings.resolvingAddress,
                    style: const TextStyle(color: AppColor.textMuted),
                  ),
                ],
              )
            else if (hasSelected)
              Text(
                selected.address ??
                    strings.addressLookupFailedWithCoord(
                      selected.coordinateLabel,
                    ),
                style: const TextStyle(color: AppColor.textBody),
              )
            else
              Text(
                strings.tapMapToPickLocation,
                style: const TextStyle(color: AppColor.textMuted),
              ),
          ],
        );
      },
    );
  }
}
