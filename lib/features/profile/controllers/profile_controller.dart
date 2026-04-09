import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage/shared_prefs.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../auth/domain/models/user_model.dart';
import '../../settings/controllers/settings_controller.dart';
import '../domain/services/profile_service.dart';

class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileDataUseCase _updateProfileUseCase;

  ProfileController({
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileDataUseCase updateProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _updateProfileUseCase = updateProfileUseCase;

  final isLoading = false.obs;
  Rx<UserModel?> userProfile = Rx<UserModel?>(null);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final RxString gender = 'male'.obs;
  final RxString reminderTime = '00:00'.obs;
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

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
        // Read existing user data to preserve fields like user_types
        final existingUserJson = SharedPrefs.getString(AppConstants.userData);
        UserModel mergedUser = user;

        if (existingUserJson != null) {
          final existingUser = UserModel.fromJsonString(existingUserJson);
          if (existingUser != null) {
            // Merge response into existing data to preserve fields like userTypes
            mergedUser = existingUser.copyWith(
              name: user.name,
              email: user.email,
              gender: user.gender,
              reminderTime: user.reminderTime,
              profilePhoto: user.profilePhoto,
              profileComplete: user.profileComplete,
              settings: user.settings ?? existingUser.settings,
              // Only update userTypes if the response has data, otherwise keep existing
              userTypes: user.userTypes.isNotEmpty ? user.userTypes : existingUser.userTypes,
            );
          }
        }

        userProfile.value = mergedUser;
        // Update local storage with merged data
        await SharedPrefs.setString(AppConstants.userData, mergedUser.toJsonString());
        
        // Populate text controllers
        nameController.text = user.name;
        emailController.text = user.email ?? '';
        phoneController.text = user.mobile;
        gender.value = user.gender ?? 'male';
        
        // Sanitize reminder time to HH:MM format (remove seconds if present)
        String rTime = user.reminderTime ?? '09:00';
        if (rTime.contains(':')) {
          final parts = rTime.split(':');
          if (parts.length >= 2) {
            reminderTime.value = '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
          } else {
            reminderTime.value = '09:00';
          }
        } else {
          reminderTime.value = '09:00';
        }
      } else {
        CustomSnackbar.showError(_getProfileUseCase.lastErrorMessage ?? 'Failed to load profile');
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      CustomSnackbar.showError('Error picking image: $e');
    }
  }

  Future<void> updateProfile() async {
    if (nameController.text.isEmpty) {
      CustomSnackbar.showError('Name cannot be empty');
      return;
    }

    try {
      isLoading.value = true;
      final user = await _updateProfileUseCase.execute(
        name: nameController.text,
        email: emailController.text,
        gender: gender.value,
        reminderTime: reminderTime.value,
        profilePhoto: selectedImage.value,
      );

      if (user != null) {
        // Read existing user data to preserve user_types if missing in response
        final existingUserJson = SharedPrefs.getString(AppConstants.userData);
        UserModel mergedUser = user;

        if (existingUserJson != null) {
          final existingUser = UserModel.fromJsonString(existingUserJson);
          if (existingUser != null) {
            // Merge response into existing data to preserve fields like userTypes
            mergedUser = existingUser.copyWith(
              name: user.name,
              email: user.email,
              gender: user.gender,
              reminderTime: user.reminderTime,
              profilePhoto: user.profilePhoto,
              profileComplete: user.profileComplete,
              settings: user.settings ?? existingUser.settings,
              // Keep existing userTypes as they are not returned by update API
              userTypes: existingUser.userTypes,
            );
          }
        }

        userProfile.value = mergedUser;
        // Update local storage with merged data
        await SharedPrefs.setString(AppConstants.userData, mergedUser.toJsonString());
        
        CustomSnackbar.showSuccess('Profile updated successfully');
        
        // Refresh settings screen if it exists
        if (Get.isRegistered<SettingsController>()) {
          Get.find<SettingsController>().refreshProfile();
        }
        
        Get.back();
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

// ─── Use Cases ──────────────────────────────────────────────────────────────

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

class UpdateProfileDataUseCase {
  final ProfileService _profileService;
  String? lastErrorMessage;

  UpdateProfileDataUseCase(this._profileService);

  Future<UserModel?> execute({
    required String name,
    required String email,
    required String gender,
    required String reminderTime,
    XFile? profilePhoto,
  }) async {
    final response = await _profileService.updateProfile(
      name: name,
      email: email,
      gender: gender,
      reminderTime: reminderTime,
      profilePhoto: profilePhoto,
    );

    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final userData = body['user'] ?? body;
        return UserModel.fromJson(userData as Map<String, dynamic>);
      } catch (e) {
        lastErrorMessage = 'Failed to parse updated profile: $e';
        return null;
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}
