import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/domain/models/user_model.dart';
import '../domain/services/profile_service.dart';

class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;

  ProfileController({required GetProfileUseCase getProfileUseCase})
      : _getProfileUseCase = getProfileUseCase;

  final isLoading = false.obs;
  Rx<UserModel?> userProfile = Rx<UserModel?>(null);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final user = await _getProfileUseCase.execute();
      if (user != null) {
        userProfile.value = user;
        // Populate text controllers
        nameController.text = user.name;
        emailController.text = ''; // API doesn't return email
        phoneController.text = user.mobile;
      } else {
        CustomSnackbar.showError(_getProfileUseCase.lastErrorMessage ?? 'Failed to load profile');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

// ─── Use Case ────────────────────────────────────────────────────────────────

class GetProfileUseCase {
  final ProfileService _profileService;
  String? lastErrorMessage;

  GetProfileUseCase(this._profileService);

  Future<UserModel?> execute() async {
    final response = await _profileService.getProfile();
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final userData = body['user'] ?? body;
        return UserModel.fromJson(userData as Map<String, dynamic>);
      } catch (_) {
        lastErrorMessage = 'Failed to parse profile data';
        return null;
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}
