import 'package:credit_debit/core/services/storage/token_manger.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage/shared_prefs.dart';
import '../../../../core/services/network/response_model.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import 'auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  @override
  Future<ResponseModel> signup(String name, String mobile) async {
    return await _authRepository.signup(name, mobile);
  }

  @override
  Future<ResponseModel> login(String mobile) async {
    return await _authRepository.login(mobile);
  }

  @override
  Future<ResponseModel> sendOtp(String mobile) async {
    return await _authRepository.sendOtp(mobile);
  }

  @override
  Future<ResponseModel> updateUserTypes(List<String> userTypes) async {
    final response = await _authRepository.updateUserTypes(userTypes);
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final userData = body['user'] ?? body;
        final user = UserModel.fromJson(userData as Map<String, dynamic>);
        await saveUserInfo(user);
      } catch (e) {
        print('Error saving user types: $e');
      }
    }
    // After selecting user types, profile is complete → userStatus = 3
    if (response.isSuccess) {
      await SharedPrefs.setInt(AppConstants.userStatus, 3);
    }
    return response;
  }

  @override
  Future<ResponseModel> updateProfile({
    required String name,
    required String gender,
    required String reminderTime,
  }) async {
    final response = await _authRepository.updateProfile(
      name: name,
      gender: gender,
      reminderTime: reminderTime,
    );
    // Auto-save updated user to SharedPrefs
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final userData = body['user'] ?? body;
        final user = UserModel.fromJson(userData as Map<String, dynamic>);
        await saveUserInfo(user);
        // Profile setup done → userStatus = 2 (next: choose role)
        await SharedPrefs.setInt(AppConstants.userStatus, 2);
      } catch (e) {
        print('Error saving profile data: $e');
      }
    }
    return response;
  }

  @override
  Future<ResponseModel> verifyOtp(String mobile, String otp) async {
    final response = await _authRepository.verifyOtp(mobile, otp);

    // API response: { status: true, data: { token, user_status, user } }
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;

        // Save token
        final token = body['token'];
        if (token != null && token.toString().isNotEmpty) {
          await saveUserToken(token.toString());
        }

        // Save user_status (1 = profile incomplete, 2 = complete)
        final userStatusVal = body['user_status'];
        if (userStatusVal != null) {
          await SharedPrefs.setInt(
              AppConstants.userStatus, int.parse(userStatusVal.toString()));
        }

        // Save user data
        final userData = body['user'];
        if (userData != null) {
          final user = UserModel.fromJson(userData as Map<String, dynamic>);
          await saveUserInfo(user);
        }

        await SharedPrefs.setBool(AppConstants.isLoggedIn, true);
      } catch (e) {
        print('Error saving user data: $e');
      }
    }

    return response;
  }

  @override
  Future<void> saveUserInfo(UserModel user) async {
    await SharedPrefs.setString(AppConstants.userData, user.toJsonString());
  }

  @override
  Future<void> saveUserToken(String userToken) async {
    await TokenManager.saveToken(userToken);
  }

  @override
  Future<void> clearUserInfo() async {
    await SharedPrefs.remove(AppConstants.userData);
    await SharedPrefs.remove(AppConstants.userStatus);
    await TokenManager.clearToken();
    await SharedPrefs.setBool(AppConstants.isLoggedIn, false);
  }

  @override
  Future<ResponseModel> logoutFromServer() async {
    // Call API first, then clear local data regardless of response
    final response = await _authRepository.logoutFromServer();
    await clearUserInfo();
    return response;
  }

  @override
  Future<bool> isLoggedIn() async {
    return SharedPrefs.getBool(AppConstants.isLoggedIn) ?? false;
  }

  @override
  Future<UserModel?> getUserInfo() async {
    final userJsonString = SharedPrefs.getString(AppConstants.userData);
    if (userJsonString == null || userJsonString.isEmpty) {
      return null;
    }
    return UserModel.fromJsonString(userJsonString);
  }
}