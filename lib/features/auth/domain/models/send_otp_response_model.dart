class SendOtpResponseModel {
  final int expiresInSeconds;
  final int? otpDebug;
  final String message;

  SendOtpResponseModel({
    required this.expiresInSeconds,
    this.otpDebug,
    this.message = 'OTP sent successfully',
  });

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SendOtpResponseModel(
      expiresInSeconds: json['expires_in_seconds'] ?? 600,
      otpDebug: json['otp_debug'],
      message: json['message'] ?? 'OTP sent successfully',
    );
  }
}
