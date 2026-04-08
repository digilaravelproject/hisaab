import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/response_model.dart';

class SettingsRepository {
  final ApiClient _apiClient;

  SettingsRepository(this._apiClient);

  Future<ResponseModel> fetchSettings() async {
    return await _apiClient.get(
      AppConstants.getSettingsUrl,
      handleError: false,
    );
  }

  Future<ResponseModel> updateNotifications(bool enabled) async {
    return await _apiClient.post(
      AppConstants.updateNotificationsUrl,
      data: {'notifications_enabled': enabled},
      handleError: false,
    );
  }

  Future<ResponseModel> updateBiometric(bool enabled) async {
    return await _apiClient.post(
      AppConstants.updateBiometricUrl,
      data: {'biometric_enabled': enabled},
      handleError: false,
    );
  }

  Future<ResponseModel> setPin(String pin) async {
    return await _apiClient.post(
      AppConstants.setPinUrl,
      data: {'pin': pin},
      handleError: false,
    );
  }
}
