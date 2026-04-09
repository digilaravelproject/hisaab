import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/models/language_model.dart';
import '../../../core/services/storage/shared_prefs.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/domain/models/user_model.dart';
import '../domain/models/settings_model.dart';
import '../domain/services/settings_service.dart';
import '../../profile/domain/services/profile_service.dart';

class BankAccount {
  final String name;
  final String type;
  final String lastFour;
  final String icon;

  BankAccount({
    required this.name,
    required this.type,
    required this.lastFour,
    required this.icon,
  });
}

class SettingsController extends GetxController {
  final SettingsService _settingsService;
  final ProfileService _profileService;

  SettingsController(this._settingsService, this._profileService);

  // Profile
  final userName = ''.obs;
  final userRole = ''.obs;
  final userGender = ''.obs;
  final userEmail = ''.obs;
  final appVersion = '1.0.2'.obs;
  final isLoading = false.obs;

  // App Settings
  final selectedLanguage = 'English'.obs;
  final reminderTime = const TimeOfDay(hour: 8, minute: 0).obs;
  final isNotificationsEnabled = false.obs;
  final isDarkModeEnabled = false.obs;
  final isBiometricEnabled = false.obs;

  // Budget
  final weeklyBudget = 0.0.obs;
  final monthlyBudget = 0.0.obs;

  // Bank accounts
  final bankAccounts = <BankAccount>[
    BankAccount(name: 'HDFC Bank', type: 'Personal', lastFour: '8821', icon: '🏦'),
    BankAccount(name: 'ICICI Bank', type: 'Business', lastFour: '4452', icon: '🏢'),
  ].obs;

  final List<Language> languages = [
    Language(code: 'en', name: 'English', nativeName: 'English', symbol: 'A'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', symbol: 'अ'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी', symbol: 'म'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', symbol: 'ક'),
    Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', symbol: 'த'),
    Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', symbol: 'తె'),
    Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', symbol: 'ಕ'),
    Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', symbol: 'म'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', symbol: 'ব'),
    Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', symbol: 'ਪ'),
    Language(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', symbol: 'ଓ'),
    Language(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া', symbol: 'অ'),
  ];

  //final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile(); // Fetch fresh data from Profile API on init
    _loadUserFromPrefs();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _profileService.getProfile();
      if (response.isSuccess && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        // API response sometimes nests user data under 'data' and then 'user'
        final data = body['data'] ?? body;
        final userData = (data is Map && data.containsKey('user')) ? data['user'] : data;
        
        final user = UserModel.fromJson(userData as Map<String, dynamic>);
        
        // Merge with existing data to preserve local-only fields
        final existingUserJson = SharedPrefs.getString(AppConstants.userData);
        UserModel mergedUser = user;
        if (existingUserJson != null) {
          final existingUser = UserModel.fromJsonString(existingUserJson);
          if (existingUser != null) {
            mergedUser = existingUser.copyWith(
              name: user.name,
              email: user.email,
              gender: user.gender,
              reminderTime: user.reminderTime,
              profilePhoto: user.profilePhoto,
              profileComplete: user.profileComplete,
              settings: user.settings ?? existingUser.settings,
              userTypes: user.userTypes.isNotEmpty ? user.userTypes : existingUser.userTypes,
            );
          }
        }

        // Update local storage
        await SharedPrefs.setString(AppConstants.userData, mergedUser.toJsonString());
        
        // Refresh local Rx variables
        _loadUserFromPrefs();
      }
    } catch (e) {
      debugPrint('Error fetching profile in settings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Public refresh ───────────────────────────────────────────────────────

  /// Call this after role/profile update to sync UI from SharedPrefs
  void refreshProfile() {
    _loadUserFromPrefs();
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  void _loadUserFromPrefs() {
    final userJson = SharedPrefs.getString(AppConstants.userData);
    if (userJson == null || userJson.isEmpty) return;
    final user = UserModel.fromJsonString(userJson);
    if (user == null) return;

    userName.value = user.name.isNotEmpty ? user.name : 'User';
    userGender.value = user.gender ?? '';
    userRole.value = user.userTypes.isNotEmpty
        ? user.userTypes
            .map((e) => e
                .toString()
                .split('_')
                .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
                .join(' '))
            .join(', ')
        : 'No role selected';

    // Populate settings from UserModel
    if (user.settings != null) {
      isNotificationsEnabled.value = user.settings!.notificationsEnabled;
      isBiometricEnabled.value = user.settings!.biometricEnabled;
      if (user.settings!.weeklyBudgetLimit != null) {
        weeklyBudget.value = user.settings!.weeklyBudgetLimit!;
      }
      if (user.settings!.monthlyBudgetLimit != null) {
        monthlyBudget.value = user.settings!.monthlyBudgetLimit!;
      }
    }

    // Populate reminder time
    String? rTime = user.reminderTime ?? user.settings?.dailyReminderTime;
    if (rTime != null && rTime.contains(':')) {
      final parts = rTime.split(':');
      if (parts.length >= 2) {
        reminderTime.value = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
  }

  Future<void> _fetchSettings() async {
    try {
      final response = await _settingsService.fetchSettings();
      if (response.isSuccess && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        final settingsJson = (body['settings'] ?? body) as Map<String, dynamic>;
        _applySettings(SettingsModel.fromJson(settingsJson));
      }
    } catch (_) {}
  }

  void _applySettings(SettingsModel s) {
    isNotificationsEnabled.value = s.notificationsEnabled;
    isBiometricEnabled.value = s.biometricEnabled;
    if (s.weeklyBudgetLimit != null) weeklyBudget.value = s.weeklyBudgetLimit!;
    if (s.monthlyBudgetLimit != null) monthlyBudget.value = s.monthlyBudgetLimit!;
    if (s.dailyReminderTime != null) {
      final parts = s.dailyReminderTime!.split(':');
      if (parts.length >= 2) {
        reminderTime.value = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
  }

  // ─── Notifications ────────────────────────────────────────────────────────

  Future<void> toggleNotifications(bool enabled) async {
    isNotificationsEnabled.value = enabled;
    try {
      final response = await _settingsService.updateNotifications(enabled);
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(
            response.message.isNotEmpty ? response.message : 'Notification setting updated');
      } else {
        isNotificationsEnabled.value = !enabled;
        CustomSnackbar.showError(
            response.message.isNotEmpty ? response.message : 'Failed to update');
      }
    } catch (_) {
      isNotificationsEnabled.value = !enabled;
      CustomSnackbar.showError('Something went wrong');
    }
  }

  Future<void> toggleBiometric(bool enabled) async {
    isBiometricEnabled.value = enabled;
    try {
      final response = await _settingsService.updateBiometric(enabled);
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(
            response.message.isNotEmpty ? response.message : 'Biometric setting updated');
      } else {
        isBiometricEnabled.value = !enabled;
        CustomSnackbar.showError(
            response.message.isNotEmpty ? response.message : 'Failed to update');
      }
    } catch (_) {
      isBiometricEnabled.value = !enabled;
      CustomSnackbar.showError('Something went wrong');
    }
  }

  Future<bool> setPin(String pin) async {
    try {
      final response = await _settingsService.setPin(pin);
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(
            response.message.isNotEmpty ? response.message : 'PIN set successfully',
            title: 'Security');
        return true;
      } else {
        CustomSnackbar.showError(
            response.message.isNotEmpty ? response.message : 'Failed to set PIN');
        return false;
      }
    } catch (_) {
      CustomSnackbar.showError('Something went wrong');
      return false;
    }
  }

  // ─── Language ─────────────────────────────────────────────────────────────

  void updateLanguage(Language lang) {
    selectedLanguage.value = lang.name;
    Get.back();
    CustomSnackbar.showSuccess('App language set to ${lang.name}',
        title: 'Language Updated');
  }

  // ─── Bank ─────────────────────────────────────────────────────────────────

  void addBank(BankAccount bank) {
    bankAccounts.add(bank);
    CustomSnackbar.showSuccess('Bank added successfully');
  }

  void removeBank(int index) {
    bankAccounts.removeAt(index);
    CustomSnackbar.showInfo('Bank removed');
  }

  // ─── Reminder Time ────────────────────────────────────────────────────────

  Future<void> selectReminderTime(BuildContext context) async {
    TimeOfDay selectedTime = reminderTime.value;
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setModalState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications_active_outlined,
                      color: AppColors.primaryColor),
                ),
                const SizedBox(width: 16),
                const Text('Reminder Time',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 32),
              Center(
                child: InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primaryColor,
                            onPrimary: Colors.white,
                            onSurface: AppColors.slate800,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) setModalState(() => selectedTime = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      selectedTime.format(context),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                  child: Text('Tap to change time',
                      style: TextStyle(color: Colors.grey, fontSize: 14))),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final hourStr = selectedTime.hour.toString().padLeft(2, '0');
                    final minuteStr = selectedTime.minute.toString().padLeft(2, '0');
                    final timeStr = '$hourStr:$minuteStr';

                    isLoading.value = true;
                    final response = await _settingsService.updateReminderTime(timeStr);
                    isLoading.value = false;

                    if (response.isSuccess) {
                      reminderTime.value = selectedTime;
                      
                      // Update SharedPrefs with the new reminder time
                      final userJson = SharedPrefs.getString(AppConstants.userData);
                      if (userJson != null) {
                        final user = UserModel.fromJsonString(userJson);
                        if (user != null) {
                          final updatedUser = user.copyWith(
                            reminderTime: timeStr,
                            settings: user.settings?.copyWith(dailyReminderTime: timeStr) ??
                                      UserSettings(dailyReminderTime: timeStr),
                          );
                          await SharedPrefs.setString(AppConstants.userData, updatedUser.toJsonString());
                        }
                      }

                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        CustomSnackbar.showSuccess('Daily reminder set for $timeStr');
                      });
                    } else {
                      CustomSnackbar.showError(
                        response.message.isNotEmpty ? response.message : 'Failed to update reminder time',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Save Selection',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  // ─── Budget ───────────────────────────────────────────────────────────────

  void updateBudget(BuildContext context, bool isWeekly) {
    final type = isWeekly ? 'Weekly' : 'Monthly';
    final budget = isWeekly ? weeklyBudget : monthlyBudget;
    final textController =
        TextEditingController(text: budget.value.toInt().toString());

    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Row(children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isWeekly
                      ? Icons.trending_up_rounded
                      : Icons.pie_chart_outline_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Text('Set $type Budget',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 32),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
                hintText: '0',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 24),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [500, 1000, 2000, 5000, 10000].map((amount) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text('+₹$amount'),
                      onPressed: () {
                        final current =
                            double.tryParse(textController.text) ?? 0;
                        textController.text =
                            (current + amount).toInt().toString();
                      },
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide.none,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final val = double.tryParse(textController.text);
                  if (val != null) {
                    if (isWeekly) {
                      isLoading.value = true;
                      final response = await _settingsService.updateWeeklyBudget(val);
                      isLoading.value = false;

                      if (response.isSuccess) {
                        budget.value = val;
                        // Synchronize SharedPrefs so other screens are in sync
                        final userJson = SharedPrefs.getString(AppConstants.userData);
                        if (userJson != null) {
                          final user = UserModel.fromJsonString(userJson);
                          if (user != null) {
                            final updatedUser = user.copyWith(
                              settings: user.settings?.copyWith(weeklyBudgetLimit: val) ??
                                        UserSettings(weeklyBudgetLimit: val),
                            );
                            await SharedPrefs.setString(AppConstants.userData, updatedUser.toJsonString());
                          }
                        }
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          CustomSnackbar.showSuccess('Weekly budget updated successfully');
                        });
                      } else {
                        CustomSnackbar.showError(
                          response.message.isNotEmpty ? response.message : 'Failed to update budget',
                        );
                      }
                    } else {
                      // Monthly budget
                      isLoading.value = true;
                      final response = await _settingsService.updateMonthlyBudget(val);
                      isLoading.value = false;

                      if (response.isSuccess) {
                        budget.value = val;
                        // Synchronize SharedPrefs so other screens are in sync
                        final userJson = SharedPrefs.getString(AppConstants.userData);
                        if (userJson != null) {
                          final user = UserModel.fromJsonString(userJson);
                          if (user != null) {
                            final updatedUser = user.copyWith(
                              settings: user.settings?.copyWith(monthlyBudgetLimit: val) ??
                                        UserSettings(monthlyBudgetLimit: val),
                            );
                            await SharedPrefs.setString(AppConstants.userData, updatedUser.toJsonString());
                          }
                        }
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          CustomSnackbar.showSuccess('Monthly budget updated successfully');
                        });
                      } else {
                        CustomSnackbar.showError(
                          response.message.isNotEmpty ? response.message : 'Failed to update budget',
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Obx(() => isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save Budget',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      )

     //
    );
  }

  // ─── Cache ────────────────────────────────────────────────────────────────

  void clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Cache?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'This will free up local storage space. Your transaction data will not be affected.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              
              // Show loading if needed, or just call the API
              final response = await _settingsService.clearCache();
              
              if (response.isSuccess) {
                CustomSnackbar.showSuccess(
                    response.message.isNotEmpty ? response.message : 'Cache cleared successfully',
                    title: 'Done');
              } else {
                CustomSnackbar.showError(
                    response.message.isNotEmpty ? response.message : 'Failed to clear cache');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  // ─── Misc ─────────────────────────────────────────────────────────────────

  void showPlaceholderAction(String title) {
    CustomSnackbar.showInfo(
        'This feature will be available in the next update.',
        title: title);
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 300), () {
                Get.find<AuthController>().logout();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
