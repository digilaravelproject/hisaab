import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/response_model.dart';
import 'help_support_repository_interface.dart';

class HelpSupportRepository implements HelpSupportRepositoryInterface {
  final ApiClient _apiClient;

  HelpSupportRepository(this._apiClient);

  @override
  Future<ResponseModel> getStaticPage(String path) async {
    return await _apiClient.get(
      path,
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> submitContactUs(Map<String, dynamic> data) async {
    return await _apiClient.post(
      AppConstants.contactUsUrl,
      data: data,
    );
  }
}
