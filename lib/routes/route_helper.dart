import 'package:get/get.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/profile_setup_screen.dart';
import '../features/bank/screens/bank_account_linking_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/language/page/language_selection_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import 'app_routes.dart';

class RouteHelper {
  static String getSplashRoute() => AppRoutes.splash;
  static String getLoginRoute() => AppRoutes.login;
  static String getSignupRoute() => AppRoutes.signup;
  static String getOtpRoute() => AppRoutes.otp;
  static String getHomeRoute() => AppRoutes.home;
  static String getLanguageRoute() => AppRoutes.languageSelection;
  static String getProfileSetupRoute() => AppRoutes.profileSetup;
  static String getBankLinkRoute() => AppRoutes.bankLink;

  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () =>  LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.languageSelection,
      page: () => LanguageSelectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => const ProfileSetupScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.bankLink,
      page: () => const BankAccountLinkingScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
