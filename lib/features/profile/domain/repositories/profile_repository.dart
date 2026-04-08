import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
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
}
