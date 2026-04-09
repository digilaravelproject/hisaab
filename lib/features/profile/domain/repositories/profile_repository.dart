import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/multipart.dart';
import '../../../../core/services/network/response_model.dart';
import 'profile_repository_interface.dart';

class ProfileRepository implements ProfileRepositoryInterface {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  @override
  Future<ResponseModel> getProfile() async {
    return await _apiClient.get(
      AppConstants.getProfileUrl,
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> updateProfile({
    required String name,
    required String email,
    required String gender,
    required String reminderTime,
    XFile? profilePhoto,
  }) async {
    Map<String, String> body = {
      'name': name,
      'email': email,
      'gender': gender,
      'reminder_time': reminderTime,
    };

    List<MultipartBody> multipartBody = [];
    if (profilePhoto != null) {
      multipartBody.add(MultipartBody('profile_photo', profilePhoto));
    }

    return await _apiClient.postMultipartData(
      AppConstants.updateProfileUrl,
      body,
      multipartBody,
      [], // No other files
    );
  }
}
