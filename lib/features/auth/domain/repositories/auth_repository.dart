import 'dart:async';
import 'package:dio/dio.dart' as dio;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/response_model.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  @override
  Future<ResponseModel> signup(String name, String mobile) async {
    return await _apiClient.post(
      AppConstants.userSignupUrl,
      data: {'name': name, 'mobile': mobile},
    );
  }

  @override
  Future<ResponseModel> login(String mobile) async {
    return await _apiClient.post(
      AppConstants.userLoginUrl,
      data: {'mobile': mobile},
    );
  }

  @override
  Future<ResponseModel> verifyOtp(String mobile, String otp) async {
    final formData = dio.FormData.fromMap({'mobile': mobile, 'otp': otp});
    return await _apiClient.post(
      AppConstants.otpVerifyUrl,
      data: formData,
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> sendOtp(String mobile) async {
    // Uses multipart/form-data as required by the API
    // handleError: false -> uses checkApi() which supports status:true format
    final formData = dio.FormData.fromMap({'mobile': mobile});
    return await _apiClient.post(
      AppConstants.sendOtpUrl,
      data: formData,
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> updateUserTypes(List<String> userTypes) async {
    return await _apiClient.post(
      AppConstants.updateUserTypesUrl,
      data: {'user_types': userTypes},
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> logoutFromServer() async {
    return await _apiClient.post(
      AppConstants.logoutUrl,
      handleError: false,
    );
  }

  @override
  Future<ResponseModel> updateProfile({
    required String name,
    required String gender,
    required String reminderTime,
  }) async {
    final formData = dio.FormData.fromMap({
      'name': name,
      'gender': gender,
      'reminder_time': reminderTime,
    });
    return await _apiClient.post(
      AppConstants.updateProfileUrl,
      data: formData,
      handleError: false,
    );
  }
}