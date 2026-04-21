import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../core/api_client.dart';
import '../../../core/base_result_state.dart';
import '../../../core/config.dart';
import '../../../shared/model/api_response.dart';
import '../model/selected_location.dart';

class AddStoryProvider extends ChangeNotifier {
  AddStoryProvider({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final ImagePicker _picker = ImagePicker();

  BaseResultState<void> _state = const BaseResultStateInitial<void>();
  XFile? _selectedImage;
  SelectedLocation? _selectedLocation;

  BaseResultState<void> get state => _state;
  XFile? get selectedImage => _selectedImage;
  SelectedLocation? get selectedLocation => _selectedLocation;

  Future<void> pickImage() async {
    final result = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (result == null) return;

    _selectedImage = result;
    notifyListeners();
  }

  void setSelectedLocation(SelectedLocation location) {
    _selectedLocation = location;
    notifyListeners();
  }

  Future<void> submitStory({required String description}) async {
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

      if (AppConfig.canUseMap && _selectedLocation != null) {
        fields['lat'] = _selectedLocation!.latitude.toString();
        fields['lon'] = _selectedLocation!.longitude.toString();
      }

      final response = await _apiClient
          .multipartPost('/stories', fields: fields, files: [photoFile])
          .timeout(AppConfig.requestTimeout);

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final apiResponse = BasicResponse.fromJson(decoded);
      if (response.statusCode >= 400 || apiResponse.error) {
        throw Exception(
          apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Failed to upload story',
        );
      }

      _selectedImage = null;
      _selectedLocation = null;
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
}
