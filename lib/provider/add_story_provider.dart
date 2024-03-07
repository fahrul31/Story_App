import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/db/auth_repository.dart';
import 'package:story_app/model/register_result.dart';
import '../api/api_service.dart';

class AddStoryProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  AddStoryProvider({
    required this.authRepository,
    required this.apiService,
  });

  late DefaultResult _addStoryResult;
  late bool _isLoadingForm = false;
  bool _isSuccess = false;
  XFile? _photo;
  String? _photoPath;
  LatLng? _pickMap;

  DefaultResult get addStoryResult => _addStoryResult;
  bool get isLoadingForm => _isLoadingForm;
  bool get isSuccess => _isSuccess;
  XFile? get photo => _photo;
  String? get photoPath => _photoPath;
  LatLng? get pickMap => _pickMap;

  set isSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  set photo(XFile? value) {
    _photo = value;
    notifyListeners();
  }

  set photoPath(String? value) {
    _photoPath = value;
    notifyListeners();
  }

  set pickMap(LatLng? value) {
    _pickMap = value;
    notifyListeners();
  }

  Future<bool> addStory(String description) async {
    _isLoadingForm = true;
    notifyListeners();
    final user = await authRepository.getUser();
    if (user != null && description.isNotEmpty && _pickMap != null) {
      String token = user.token;
      final response = await apiService.addStory(
        token,
        _photo!,
        description,
        _pickMap!.latitude,
        _pickMap!.longitude,
      );
      _addStoryResult = response;
      notifyListeners();
      if (!response.error) {
        _isSuccess = true;
        notifyListeners();
      }
    } else if (user != null && description.isNotEmpty) {
      String token = user.token;
      final response = await apiService.addStory(
        token,
        _photo!,
        description,
      );
      _addStoryResult = response;
      notifyListeners();
      if (!response.error) {
        _isSuccess = true;
        notifyListeners();
      }
    }

    _isLoadingForm = false;
    notifyListeners();

    return _isSuccess;
  }
}
