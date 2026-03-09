import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/models/language_model.dart';
import '../../../routes/app_routes.dart';

class BankAccount {
  final String name;
  final String type; // Personal / Business
  final String lastFour;
  final String icon;

  BankAccount({required this.name, required this.type, required this.lastFour, required this.icon});
}

class SettingsController extends GetxController {
  // Profile
  final userName = 'Firoz Khan'.obs;
  final userRole = 'Business Owner'.obs;
  final userGender = 'Male'.obs;
  final userEmail = 'firoz.khan@digiemperor.com'.obs;
  final appVersion = '1.0.2'.obs;
  
  // App Settings
  final selectedLanguage = 'English'.obs;
  final reminderTime = const TimeOfDay(hour: 8, minute: 0).obs;
  final isNotificationsEnabled = true.obs;
  final isDarkModeEnabled = false.obs;
  final isBiometricEnabled = false.obs;

  // Budget
  final weeklyBudget = 5000.0.obs;
  final monthlyBudget = 25000.0.obs;

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
    Language(code: 'as', name: 'Assamese', nativeName: 'অসমীया', symbol: 'অ'),
  ];

  void updateLanguage(Language lang) {
    selectedLanguage.value = lang.name;
    Get.back();
    CustomSnackbar.showSuccess('App language set to ${lang.name}', title: 'Language Updated');
  }
  final bankAccounts = <BankAccount>[
    BankAccount(name: 'HDFC Bank', type: 'Personal', lastFour: '8821', icon: '🏦'),
    BankAccount(name: 'ICICI Bank', type: 'Business', lastFour: '4452', icon: '🏢'),
  ].obs;


  void addBank(BankAccount bank) {
    bankAccounts.add(bank);
    CustomSnackbar.showSuccess('Bank added successfully');
  }

  void removeBank(int index) {
    bankAccounts.removeAt(index);
    CustomSnackbar.showInfo('Bank removed');
  }

  Future<void> selectReminderTime(BuildContext context) async {
    TimeOfDay selectedTime = reminderTime.value;
    
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Reminder Time',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.primaryColor,
                                onPrimary: Colors.white,
                                onSurface: AppColors.slate800,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setModalState(() => selectedTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(
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
                  child: Text(
                    'Tap to change time',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final timeStr = selectedTime.format(context);
                      reminderTime.value = selectedTime;
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 500), () {
                        CustomSnackbar.showSuccess(
                          'Daily reminder set for $timeStr',
                          title: 'Reminder Updated'
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text('Save Selection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }
      ),
      isScrollControlled: false,
    );
  }

  void updateBudget(BuildContext context, bool isWeekly) {
    String type = isWeekly ? 'Weekly' : 'Monthly';
    RxDouble budget = isWeekly ? weeklyBudget : monthlyBudget;
    final textController = TextEditingController(text: budget.value.toInt().toString());

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isWeekly ? Icons.trending_up_rounded : Icons.pie_chart_outline_rounded,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Set $type Budget',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                hintText: '0',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                        double current = double.tryParse(textController.text) ?? 0;
                        textController.text = (current + amount).toInt().toString();
                      },
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                onPressed: () {
                  double? val = double.tryParse(textController.text);
                  if (val != null) {
                    budget.value = val;
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 500), () {
                      CustomSnackbar.showSuccess('$type budget updated to ₹${NumberFormat('#,###').format(val)}');
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: false,
    );
  }

  void clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Cache?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This will free up local storage space. Your transaction data will not be affected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 300), () {
                CustomSnackbar.showSuccess('Cache cleared successfully', title: 'Done');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void showPlaceholderAction(String title) {
    CustomSnackbar.showInfo('This feature will be available in the next update.', title: title);
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Future.delayed(const Duration(milliseconds: 300), () {
                Get.offAllNamed(AppRoutes.login);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
