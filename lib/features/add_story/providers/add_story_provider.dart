import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/api_client.dart';
import '../../../core/base_result_state.dart';
import '../../../core/config.dart';

class AddStoryProvider extends ChangeNotifier {
  AddStoryProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final ImagePicker _picker = ImagePicker();

  BaseResultState<void> _state = const BaseResultStateInitial<void>();
  XFile? _selectedImage;

  BaseResultState<void> get state => _state;
  XFile? get selectedImage => _selectedImage;

  Future<void> pickImage() async {
    final result = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (result == null) return;

    _selectedImage = result;
    notifyListeners();
  }

  Future<void> submitStory({
    required String description,
    String? latitude,
    String? longitude,
  }) async {
    if (_selectedImage == null) {
      _state = const BaseResultStateError<void>('Please choose a photo first.');
      notifyListeners();
      return;
    }

    _state = const BaseResultStateLoading<void>();
    notifyListeners();

    try {
      final photoBytes = await _selectedImage!.readAsBytes();
      final photoFile = http.MultipartFile.fromBytes(
        'photo',
        photoBytes,
        filename: _selectedImage!.name,
      );

      final fields = <String, String>{'description': description};
      final lat = _parseCoordinate(latitude);
      final lon = _parseCoordinate(longitude);
      if (lat != null) fields['lat'] = lat.toString();
      if (lon != null) fields['lon'] = lon.toString();

      final response = await _apiClient.multipartPost(
        '/stories',
        fields: fields,
        files: [photoFile],
      ).timeout(AppConfig.requestTimeout);

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400 || decoded['error'] == true) {
        throw Exception(decoded['message'] ?? 'Failed to upload story');
      }

      _selectedImage = null;
      _state = const BaseResultStateSuccess<void>(null);
    } on SocketException {
      _state = const BaseResultStateError<void>('No internet connection');
    } catch (e) {
      _state = BaseResultStateError<void>(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }

    notifyListeners();
  }

  void resetState() {
    _state = const BaseResultStateInitial<void>();
    notifyListeners();
  }

  double? _parseCoordinate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }
}

