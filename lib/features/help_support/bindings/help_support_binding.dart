import 'package:get/get.dart';
import '../../../core/services/network/api_client.dart';
import '../controllers/help_support_controller.dart';
import '../domain/repositories/help_support_repository.dart';
import '../domain/services/help_support_service.dart';
import '../domain/use_cases/contact_us_use_case.dart';
import '../domain/use_cases/get_static_page_use_case.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HelpSupportRepository(Get.find<ApiClient>()));
    Get.lazyPut(() => HelpSupportService(Get.find<HelpSupportRepository>()));
    Get.lazyPut(() => GetStaticPageUseCase(Get.find<HelpSupportService>()));
    Get.lazyPut(() => ContactUsUseCase(Get.find<HelpSupportService>()));
    Get.lazyPut(() => HelpAndSupportController(
          getStaticPageUseCase: Get.find<GetStaticPageUseCase>(),
          contactUsUseCase: Get.find<ContactUsUseCase>(),
        ));
  }
}
