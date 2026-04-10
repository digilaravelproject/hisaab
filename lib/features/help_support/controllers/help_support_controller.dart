import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage/shared_prefs.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/domain/models/user_model.dart';
import '../domain/models/static_page_model.dart';
import '../domain/use_cases/contact_us_use_case.dart';
import '../domain/use_cases/get_static_page_use_case.dart';

class HelpAndSupportController extends GetxController {
  final GetStaticPageUseCase _getStaticPageUseCase;
  final ContactUsUseCase _contactUsUseCase;

  HelpAndSupportController({
    required GetStaticPageUseCase getStaticPageUseCase,
    required ContactUsUseCase contactUsUseCase,
  })  : _getStaticPageUseCase = getStaticPageUseCase,
        _contactUsUseCase = contactUsUseCase;

  final isLoading = false.obs;
  Rx<StaticPageModel?> staticPage = Rx<StaticPageModel?>(null);
  final faqItems = <Map<String, String>>[].obs;

  // Contact Us fields
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final name = ''.obs;
  final email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void _loadUserData() {
    final userJson = SharedPrefs.getString(AppConstants.userData);
    if (userJson != null) {
      final user = UserModel.fromJsonString(userJson);
      name.value = user!.name;
      email.value = user.email ?? '';
    }
  }

  Future<void> fetchPage(String path) async {
    try {
      isLoading.value = true;
      final result = await _getStaticPageUseCase.execute(path);
      if (result != null) {
        staticPage.value = result;
        if (path.contains('faq')) {
          _parseFaqs(result.content);
        }
      } else {
        CustomSnackbar.showError(
            _getStaticPageUseCase.lastErrorMessage ?? 'Failed to load content');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitContactUs() async {
    if (subjectController.text.isEmpty || messageController.text.isEmpty) {
      CustomSnackbar.showError('Please fill all fields');
      return;
    }

    try {
      isLoading.value = true;
      final success = await _contactUsUseCase.execute(
        name: name.value,
        email: email.value,
        subject: subjectController.text,
        message: messageController.text,
      );

      if (success) {
        CustomSnackbar.showSuccess('Message sent successfully',
            title: 'Support');
        subjectController.clear();
        messageController.clear();
        Get.back();
      } else {
        CustomSnackbar.showError(
            _contactUsUseCase.lastErrorMessage ?? 'Failed to send message');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _parseFaqs(String html) {
    faqItems.clear();
    // Regex to match <h2>Quest</h2> and <p>Answer</p>
    // We assume they appear in pairs.
    final qMatches = RegExp(r'<h2>(.*?)</h2>', dotAll: true).allMatches(html).toList();
    final aMatches = RegExp(r'<p>(.*?)</p>', dotAll: true).allMatches(html).toList();

    for (int i = 0; i < qMatches.length; i++) {
      if (i < aMatches.length) {
        faqItems.add({
          'question': qMatches[i].group(1) ?? '',
          'answer': aMatches[i].group(1) ?? '',
        });
      }
    }
  }
}
