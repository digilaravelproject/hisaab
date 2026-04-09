import 'package:get/get.dart';
import '../../../core/services/network/api_client.dart';
import '../controllers/profile_controller.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/services/profile_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileRepository(Get.find<ApiClient>()));
    Get.lazyPut(() => ProfileService(Get.find<ProfileRepository>()));
    Get.lazyPut(() => GetProfileUseCase(Get.find<ProfileService>()));
    Get.lazyPut(() => UpdateProfileDataUseCase(Get.find<ProfileService>()));
    Get.lazyPut(() => ProfileController(
          getProfileUseCase: Get.find<GetProfileUseCase>(),
          updateProfileUseCase: Get.find<UpdateProfileDataUseCase>(),
        ));
  }
}
