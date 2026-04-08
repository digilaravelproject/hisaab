import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/network/response_model.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../features/settings/controllers/settings_controller.dart' show SettingsController;
import '../domain/models/send_otp_response_model.dart';
import '../domain/models/user_model.dart';
import '../domain/models/verify_otp_response_model.dart';
import '../../../routes/route_helper.dart';
import '../domain/services/auth_service.dart';
import '../screens/otp_screen.dart';

class AuthController extends GetxController {
  final SendOtpUseCase _sendOtpUseCase;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckLoginStatusUseCase _checkLoginStatusUseCase;
  final GetUserInfoUseCase _getUserInfoUseCase;
  final UpdateUserTypesUseCase _updateUserTypesUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  AuthController({
    required SendOtpUseCase sendOtpUseCase,
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckLoginStatusUseCase checkLoginStatusUseCase,
    required GetUserInfoUseCase getUserInfoUseCase,
    required UpdateUserTypesUseCase updateUserTypesUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  })  : _sendOtpUseCase = sendOtpUseCase,
        _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _logoutUseCase = logoutUseCase,
        _checkLoginStatusUseCase = checkLoginStatusUseCase,
        _getUserInfoUseCase = getUserInfoUseCase,
        _updateUserTypesUseCase = updateUserTypesUseCase,
        _updateProfileUseCase = updateProfileUseCase;

  final isLoading = false.obs;
  final currentMobile = ''.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  final loginFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    otpController.dispose();
    super.onClose();
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _checkLoginStatusUseCase.execute();
    if (isLoggedIn) {
      final user = await _getUserInfoUseCase.execute();
      if (user != null) currentUser.value = user;
    }
  }

  /// Send OTP to mobile number (new API: POST /api/v1/auth/send-otp)
  Future<void> sendOtp() async {
    if (!loginFormKey.currentState!.validate()) return;
    await sendOtpDirect(mobileController.text.trim());
  }

  /// Direct send OTP without form validation (for LoginScreen with local controller)
  Future<void> sendOtpDirect(String mobile) async {
    try {
      isLoading.value = true;
      currentMobile.value = mobile;
      final result = await _sendOtpUseCase.execute(mobile);

      if (result != null) {
        CustomSnackbar.showSuccess(result.message, title: 'Success');
        Get.to(
          () => OtpScreen1(mobileNumber: mobile),
          transition: Transition.rightToLeft,
        );
      } else {
        CustomSnackbar.showError(
            _sendOtpUseCase.lastErrorMessage ??
                'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }


/*
  Future<void> reSendOtp() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final mobile = mobileController.text.trim();
      final result = await _sendOtpUseCase.execute(mobile);

      if (result != null) {
        currentMobile.value = mobile;
        CustomSnackbar.showSuccess(result.message, title: 'Success');
        // Get.to(
        //       () => OtpScreen1(mobileNumber: mobile),
        //   transition: Transition.rightToLeft,
        // );
      } else {
        CustomSnackbar.showError(_sendOtpUseCase.lastErrorMessage ?? 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
*/

  Future<void> signup() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final user = await _registerUseCase.execute(
        nameController.text.trim(),
        mobileController.text.trim(),
      );

      if (user != null) {
        currentUser.value = user;
        currentMobile.value = mobileController.text.trim();
        CustomSnackbar.showSuccess('OTP sent to your mobile number');
        Get.toNamed(RouteHelper.getOtpRoute());
      } else {
        CustomSnackbar.showError('Signup failed. Please try again.');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final user = await _loginUseCase.execute(mobileController.text.trim());

      if (user != null) {
        currentUser.value = user;
        currentMobile.value = mobileController.text.trim();
        Get.toNamed(RouteHelper.getOtpRoute());
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length < 4) {
      CustomSnackbar.showError('Please enter a valid 4-digit OTP');
      return;
    }

    try {
      isLoading.value = true;
      final result = await _verifyOtpUseCase.execute(
        currentMobile.value,
        otpController.text.trim(),
      );

      if (result != null) {
        currentUser.value = result.user;
        otpController.clear();
        CustomSnackbar.showSuccess(result.message);

        // Navigation based on user_status from API:
        // 1 = profile setup pending
        // 2 = profile done, user types pending
        // 3+ = fully complete → dashboard
        _navigateAfterAuth(result.userStatus);
      } else {
        CustomSnackbar.showError(_verifyOtpUseCase.lastErrorMessage ?? 'Invalid OTP. Please try again.');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Central navigation logic after OTP verify / app resume
  /// user_status: 1 → profile setup, 2 → choose role, 3+ → dashboard
  void _navigateAfterAuth(int userStatus) {
    switch (userStatus) {
      case 1:
        Get.offAllNamed(RouteHelper.getProfileSetupRoute());
        break;
      case 2:
        Get.offAllNamed(RouteHelper.getChooseRoleRoute());
        break;
      default:
        Get.offAllNamed(RouteHelper.getDashboardRoute());
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final response = await _logoutUseCase.execute();
      CustomSnackbar.showSuccess(
          response.message.isNotEmpty ? response.message : 'Logged out successfully');
      currentUser.value = null;
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } catch (e) {
      // Even if API fails, clear local and navigate
      currentUser.value = null;
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserTypes(List<String> userTypes) async {
    try {
      isLoading.value = true;
      final result = await _updateUserTypesUseCase.execute(userTypes);
      if (result != null) {
        currentUser.value = result;
        CustomSnackbar.showSuccess(
            _updateUserTypesUseCase.lastMessage ?? 'Roles updated successfully');
        Get.offAllNamed(RouteHelper.getDashboardRoute());
        // Refresh settings profile display after navigation
        Future.microtask(() {
          if (Get.isRegistered<SettingsController>()) {
            Get.find<SettingsController>().refreshProfile();
          }
        });
      } else {
        CustomSnackbar.showError(
            _updateUserTypesUseCase.lastErrorMessage ?? 'Failed to update roles');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateProfile({
    required String name,
    required String gender,
    required String reminderTime,
  }) async {
    try {
      isLoading.value = true;
      final result = await _updateProfileUseCase.execute(
        name: name,
        gender: gender,
        reminderTime: reminderTime,
      );
      if (result != null) {
        currentUser.value = result;
        CustomSnackbar.showSuccess(_updateProfileUseCase.lastMessage ?? 'Profile updated successfully');
        Get.offAllNamed(RouteHelper.getChooseRoleRoute());
      } else {
        CustomSnackbar.showError(_updateProfileUseCase.lastErrorMessage ?? 'Failed to update profile');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

// ─── Use Cases ───────────────────────────────────────────────────────────────

class SendOtpUseCase {
  final AuthService _authService;
  String? lastErrorMessage;

  SendOtpUseCase(this._authService);

  Future<SendOtpResponseModel?> execute(String mobile) async {
    final response = await _authService.sendOtp(mobile);
    if (response.isSuccess) {
      try {
        if (response.body != null) {
          final model = SendOtpResponseModel.fromJson(
            response.body as Map<String, dynamic>,
          );
          return SendOtpResponseModel(
            expiresInSeconds: model.expiresInSeconds,
            otpDebug: model.otpDebug,
            message: response.message,
          );
        }
        return SendOtpResponseModel(
          expiresInSeconds: 600,
          message: response.message,
        );
      } catch (_) {
        return SendOtpResponseModel(
          expiresInSeconds: 600,
          message: response.message,
        );
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}

// Internal wrapper removed - no longer needed

class LoginUseCase {
  final AuthService _authService;

  LoginUseCase(this._authService);

  Future<UserModel?> execute(String mobile) async {
    final response = await _authService.login(mobile);
    if (response.isSuccess && response.body != null) {
      return UserModel.fromJson(response.body);
    }
    return null;
  }
}

class RegisterUseCase {
  final AuthService _authService;

  RegisterUseCase(this._authService);

  Future<UserModel?> execute(String name, String mobile) async {
    final response = await _authService.signup(name, mobile);
    if (response.isSuccess && response.body != null) {
      try {
        return UserModel.fromJson(response.body);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

class VerifyOtpUseCase {
  final AuthService _authService;
  String? lastErrorMessage;

  VerifyOtpUseCase(this._authService);

  Future<VerifyOtpResponseModel?> execute(String mobile, String otp) async {
    final response = await _authService.verifyOtp(mobile, otp);
    if (response.isSuccess && response.body != null) {
      try {
        return VerifyOtpResponseModel.fromJson(
          response.body as Map<String, dynamic>,
          response.message,
        );
      } catch (e) {
        lastErrorMessage = 'Failed to parse response';
        return null;
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}

class LogoutUseCase {
  final AuthService _authService;

  LogoutUseCase(this._authService);

  Future<ResponseModel> execute() async {
    return await _authService.logoutFromServer();
  }
}

class CheckLoginStatusUseCase {
  final AuthService _authService;

  CheckLoginStatusUseCase(this._authService);

  Future<bool> execute() async {
    return await _authService.isLoggedIn();
  }
}

class GetUserInfoUseCase {
  final AuthService _authService;

  GetUserInfoUseCase(this._authService);

  Future<UserModel?> execute() async {
    return await _authService.getUserInfo();
  }
}

class UpdateUserTypesUseCase {
  final AuthService _authService;
  String? lastMessage;
  String? lastErrorMessage;

  UpdateUserTypesUseCase(this._authService);

  Future<UserModel?> execute(List<String> userTypes) async {
    final response = await _authService.updateUserTypes(userTypes);
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final userData = body['user'] ?? body;
        lastMessage = response.message;
        return UserModel.fromJson(userData as Map<String, dynamic>);
      } catch (_) {
        lastErrorMessage = 'Failed to parse response';
        return null;
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}

class UpdateProfileUseCase {
  final AuthService _authService;
  String? lastMessage;
  String? lastErrorMessage;

  UpdateProfileUseCase(this._authService);

  Future<UserModel?> execute({
    required String name,
    required String gender,
    required String reminderTime,
  }) async {
    final response = await _authService.updateProfile(
      name: name,
      gender: gender,
      reminderTime: reminderTime,
    );
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final userData = body['user'] ?? body;
        lastMessage = response.message;
        return UserModel.fromJson(userData as Map<String, dynamic>);
      } catch (_) {
        lastErrorMessage = 'Failed to parse response';
        return null;
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}
