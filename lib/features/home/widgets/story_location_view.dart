import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/config.dart';
import '../../../shared/localization/app_strings.dart';
import '../../../shared/services/reverse_geocoding_service.dart';
import '../../../shared/theme/app_color.dart';
import '../../../shared/widgets/app_snack_bar.dart';

class StoryLocationView extends StatefulWidget {
  const StoryLocationView({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  State<StoryLocationView> createState() => _StoryLocationViewState();
}

class _StoryLocationViewState extends State<StoryLocationView> {
  final ReverseGeocodingService _geocodingService = ReverseGeocodingService();
  String? _resolvedAddress;
  bool _isResolvingAddress = false;

  Future<void> _showAddress() async {
    if (_isResolvingAddress) return;

    setState(() => _isResolvingAddress = true);
    String? address;
    try {
      address = await _geocodingService.getAddress(
        widget.latitude,
        widget.longitude,
      );
    } catch (_) {
      address = null;
    } finally {
      if (mounted) {
        setState(() => _isResolvingAddress = false);
      }
    }

    if (!mounted) return;

    _resolvedAddress = address;
    if (address != null) {
      AppSnackBar.success(context, address);
      return;
    }
    final coord =
        '${widget.latitude.toStringAsFixed(5)}, ${widget.longitude.toStringAsFixed(5)}';
    AppSnackBar.error(
      context,
      context.strings.addressLookupFailedWithCoord(coord),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final target = LatLng(widget.latitude, widget.longitude);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.location,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColor.textDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
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
                      key: const Key('story-map-placeholder'),
                    ),
                  )
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: target,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('story-location'),
                        position: target,
                        infoWindow: InfoWindow(
                          title: strings.selectedLocationTitle,
                          snippet:
                              _resolvedAddress ?? strings.tapMarkerForAddress,
                        ),
                        onTap: _showAddress,
                      ),
                    },
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    liteModeEnabled: true,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _resolvedAddress ?? strings.tapMarkerForAddress,
          style: const TextStyle(color: AppColor.textMuted),
        ),
        if (_isResolvingAddress) ...[
          const SizedBox(height: 8),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ],
    );
  }
}
