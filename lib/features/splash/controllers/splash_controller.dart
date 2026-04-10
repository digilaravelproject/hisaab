import 'dart:async';
import 'package:get/get.dart';
import '../../../core/services/storage/shared_prefs.dart';
import '../../../core/constants/app_constants.dart';
import '../../../routes/route_helper.dart';
import '../domain/services/splash_service.dart';

class SplashController extends GetxController {
  final SplashService _splashService;

  SplashController(this._splashService);

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initApp();
  }

  Future<void> initApp() async {
    try {
      isLoading.value = true;

      // Initialize splash service
      final isReady = await _splashService.initialize();

      if (isReady) {
        // Wait to show splash screen
        await Future.delayed(const Duration(milliseconds: 2500));

        // Check if user is logged in
        final isLoggedIn = SharedPrefs.getBool(AppConstants.isLoggedIn) ?? false;
        final savedUserStatus = SharedPrefs.getInt(AppConstants.userStatus) ?? 0;

        if (isLoggedIn) {
          // user_status: 1 → profile setup, 2 → choose role, 3+ → dashboard
          switch (savedUserStatus) {
            case 1:
              Get.offAllNamed(RouteHelper.getProfileSetupRoute());
              break;
            case 2:
              Get.offAllNamed(RouteHelper.getChooseRoleRoute());
              break;
            case 3:
              Get.offAllNamed(RouteHelper.getBankLinkRoute());
              break;
            default:
              Get.offAllNamed(RouteHelper.getDashboardRoute());
          }
        } else {
          Get.offAllNamed(RouteHelper.getLanguageRoute());
        }
      } else {
        // Handle maintenance or version issues
        // For now, just navigate to login
        Get.offAllNamed(RouteHelper.getLoginRoute());
      }
    } catch (e) {
      // Handle errors
      Get.offAllNamed(RouteHelper.getLoginRoute());
    } finally {
      isLoading.value = false;
    }
  }
}
