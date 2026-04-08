import '../services/config/env_config.dart';

class AppConstants {
    static String appName = EnvConfig.appName;
    static String baseUrl = EnvConfig.baseUrl;
    static const String fontFamily = 'Poppins';
    static const String defaultTag = 'PCB_APP'; // default tag for log checking

    static const bool isHandleInternetScreen = true;
    static const bool isHandleErrorScreen = false;
    static const bool handleError = true; // manages logic-level error flow.
    static const bool showToaster = false; // manages UI-level notifications.

    // API base URLs
    static  String imageUrl = '$baseUrl';

    // API endpoints
    static const String userSignupUrl = '/api/user_signup';
    static const String userLoginUrl = '/api/user_login';
    static const String otpVerifyUrl = '/api/v1/auth/verify-otp';
    static const String sendOtpUrl = '/api/v1/auth/send-otp';
    static const String updateUserTypesUrl = '/api/v1/profile/user-types';
    static const String updateProfileUrl = '/api/v1/profile/update';
    static const String getProfileUrl = '/api/v1/profile';
    static const String getSettingsUrl = '/api/v1/settings';
    static const String updateNotificationsUrl = '/api/v1/settings/notifications';
    static const String updateBiometricUrl = '/api/v1/settings/biometric';
    static const String setPinUrl = '/api/v1/settings/pin';
    static const String logoutUrl = '/api/v1/auth/logout';

    // Shared Preferences keys
    static const String theme = 'theme';
    static const String language = 'language';
    static const String token = 'token';
    static const String userData = 'user_data';
    static const String isLoggedIn = 'is_logged_in';
    static const String userStatus = 'user_status';
}
