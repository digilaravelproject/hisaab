import 'package:get/get.dart';
import '../core/services/network/api_client.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/profile_setup_screen.dart';
import '../features/bank/screens/bank_account_linking_screen.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/domain/services/settings_service.dart';
import '../features/bank/screens/connect_bank_intro_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/language/page/language_selection_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/controllers/dashboard_controller.dart';
import '../features/transactions/controllers/transaction_controller.dart';
import '../features/business/controllers/business_controller.dart';
import '../features/reports/controllers/reports_controller.dart';
import '../features/settings/controllers/settings_controller.dart';
import '../features/settings/screens/edit_profile_screen.dart';
import '../features/home/controllers/home_controller.dart';
import '../features/budget/controllers/budget_controller.dart';
import '../features/auth/screens/user_selection_type_screen.dart';
import '../features/intro/screens/intro_screen.dart';
import '../features/notification/screens/notification_screen.dart';
import '../features/notification/screens/notification_detail_screen.dart';
import '../features/transactions/screens/add_entry_screen.dart';
import '../features/settings/screens/set_pin_screen.dart';
import '../features/settings/screens/faq_screen.dart';
import '../features/settings/screens/contact_us_screen.dart';
import '../features/settings/screens/terms_screen.dart';
import '../features/settings/screens/data_backup_screen.dart';
import '../features/profile/bindings/profile_binding.dart';
import 'app_routes.dart';

class RouteHelper {
  static String getSplashRoute() => AppRoutes.splash;
  static String getLoginRoute() => AppRoutes.login;
  static String getSignupRoute() => AppRoutes.signup;
  static String getOtpRoute() => AppRoutes.otp;
  static String getHomeRoute() => AppRoutes.home;
  static String getLanguageRoute() => AppRoutes.languageSelection;
  static String getProfileSetupRoute() => AppRoutes.profileSetup;
  static String getChooseRoleRoute() => AppRoutes.chooseRole;
  static String getIntroRoute() => AppRoutes.intro;
  static String getBankLinkRoute() => AppRoutes.bankLink;
  static String getBankIntroRoute() => AppRoutes.bankIntro;
  static String getDashboardRoute() => AppRoutes.dashboard;
  static String getNotificationRoute() => AppRoutes.notification;
  static String getNotificationDetailsRoute() => AppRoutes.notificationDetails;
  static String getAddEntryRoute() => AppRoutes.addEntry;
  static String getEditProfileRoute() => AppRoutes.editProfile;
  static String getSetPinRoute() => AppRoutes.setPin;
  static String getFaqRoute() => AppRoutes.faq;
  static String getContactUsRoute() => AppRoutes.contactUs;
  static String getTermsRoute() => AppRoutes.terms;
  static String getDataBackupRoute() => AppRoutes.dataBackup;

  static final List<GetPage> routes = [
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
      page: () => OtpScreen1(
        mobileNumber: Get.arguments?['mobile'] ?? '',
      ),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TransactionController(), fenix: true);
        Get.lazyPut(() => DashboardController(), fenix: true);
      }),
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
      name: AppRoutes.chooseRole,
      page: () => const UserTypeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.intro,
      page: () => const IntroScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.bankLink,
      page: () => const BankAccountLinkingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.bankIntro,
      page: () => const ConnectBankIntroScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController());
        Get.lazyPut(() => TransactionController());
        Get.lazyPut(() => BusinessController());
        Get.lazyPut(() => ReportsController());
        Get.lazyPut(() => SettingsRepository(Get.find<ApiClient>()));
        Get.lazyPut(() => SettingsService(Get.find<SettingsRepository>()));
        Get.lazyPut(() => SettingsController(Get.find<SettingsService>()));
        Get.lazyPut(() => HomeController(), fenix: true);
        Get.lazyPut(() => BudgetController(), fenix: true);
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notificationDetails,
      page: () => NotificationDetailScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addEntry,
      page: () => const AddEntryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.setPin,
      page: () => const SetPinScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.faq,
      page: () => const FaqScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => const ContactUsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.terms,
      page: () => const TermsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dataBackup,
      page: () => const DataBackupScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
