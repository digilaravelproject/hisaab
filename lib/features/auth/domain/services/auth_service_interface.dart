import '../../../../core/services/network/response_model.dart';
import '../models/user_model.dart';

abstract class AuthServiceInterface {
  Future<ResponseModel> signup(String name, String mobile);
  Future<ResponseModel> login(String mobile);
  Future<ResponseModel> verifyOtp(String mobile, String otp);
  Future<ResponseModel> sendOtp(String mobile);
  Future<ResponseModel> updateUserTypes(List<String> userTypes);
  Future<ResponseModel> updateProfile({
    required String name,
    required String gender,
    required String reminderTime,
  });
  Future<ResponseModel> logoutFromServer();
  Future<void> saveUserToken(String userToken);
  Future<void> saveUserInfo(UserModel user);
  Future<void> clearUserInfo();
  Future<bool> isLoggedIn();
  Future<UserModel?> getUserInfo();
}
