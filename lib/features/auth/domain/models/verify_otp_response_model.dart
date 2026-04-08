import 'user_model.dart';

class VerifyOtpResponseModel {
  final String token;
  final int userStatus; // 1 = profile incomplete, 2 = complete etc.
  final UserModel user;
  final String message;

  VerifyOtpResponseModel({
    required this.token,
    required this.userStatus,
    required this.user,
    required this.message,
  });

  factory VerifyOtpResponseModel.fromJson(
      Map<String, dynamic> json, String message) {
    return VerifyOtpResponseModel(
      token: json['token'] ?? '',
      userStatus: json['user_status'] ?? 1,
      user: UserModel.fromJson(json['user'] ?? {}),
      message: message,
    );
  }
}
