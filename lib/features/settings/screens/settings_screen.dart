import 'package:credit_debit/core/models/language_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/settings_controller.dart';
import 'edit_profile_screen.dart';
import '../../auth/screens/user_selection_type_screen.dart';
import '../../bank/screens/bank_account_linking_screen.dart';
import '../../../routes/route_helper.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.slate800,
          ),
        ),
        actions: const [
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 24),
            _buildBankAccountsSection(),
            const SizedBox(height: 24),
            _buildReminderBudgetSection(context),
            const SizedBox(height: 24),
            _buildAppSettingsSection(context),
            const SizedBox(height: 24),
            _buildSecuritySection(),
            const SizedBox(height: 24),
            _buildDataBackupSection(context),
            const SizedBox(height: 24),
            _buildSupportSection(),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => Get.to(() => const EditProfileScreen()),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      controller.userName.value.substring(0, 1),
                      style: TextStyle(color: AppColors.primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        controller.userName.value,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                      Obx(() => Text(
                        controller.userRole.value,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.to(() => const EditProfileScreen()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: const Text('Edit Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.to(() => const UserTypeScreen()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: const Text('Change Role', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Bank Accounts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              ...controller.bankAccounts.asMap().entries.map((entry) {
                final index = entry.key;
                final bank = entry.value;
                return Column(
                  children: [
                    ListTile(
                      onTap: () => controller.showPlaceholderAction(bank.name),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                        child: Text(bank.icon, style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(bank.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${bank.type} • **** ${bank.lastFour}', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 20),
                        onPressed: () => controller.removeBank(index),
                      ),
                    ),
                    if (index < controller.bankAccounts.length - 1)
                      Divider(height: 1, indent: 70, color: Colors.grey.shade100),
                  ],
                );
              }),
              InkWell(
                onTap: () => Get.to(() => const BankAccountLinkingScreen()),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey.shade100)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline_rounded, size: 20, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text('Add New Bank', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildReminderBudgetSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text('Reminder & Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildControlTile(
                icon: Icons.notifications_active_outlined,
                title: 'Daily Reminder Time',
                trailing: Obx(() => Text(
                  controller.reminderTime.value.format(context),
                  style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                )),
                onTap: () => controller.selectReminderTime(context),
              ),
              Divider(height: 1, indent: 70, color: Colors.grey.shade100),
              _buildControlTile(
                icon: Icons.trending_up_rounded,
                title: 'Weekly Budget Limit',
                trailing: Obx(() => Text(
                  '₹${NumberFormat('#,###').format(controller.weeklyBudget.value)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                onTap: () => controller.updateBudget(context, true),
              ),
              Divider(height: 1, indent: 70, color: Colors.grey.shade100),
              _buildControlTile(
                icon: Icons.pie_chart_outline_rounded,
                title: 'Monthly Budget Limit',
                trailing: Obx(() => Text(
                  '₹${NumberFormat('#,###').format(controller.monthlyBudget.value)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
                onTap: () => controller.updateBudget(context, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text('App Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildControlTile(
                icon: Icons.language_rounded,
                title: 'Language',
                trailing: Obx(() => Text(controller.selectedLanguage.value, style: const TextStyle(color: Colors.grey))),
                onTap: () => _showLanguageDialog(controller),
              ),
              Divider(height: 1, indent: 70, color: Colors.grey.shade100),
              Obx(() => _buildSwitchTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                value: controller.isNotificationsEnabled.value,
                onChanged: (val) => controller.isNotificationsEnabled.value = val,
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSectionLayout(
      'Security',
      [
        _buildControlTile(
          icon: Icons.lock_outline_rounded, 
          title: 'Manage PIN', 
          trailing: const Text('Set', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
          onTap: () => Get.toNamed(RouteHelper.getSetPinRoute()),
        ),
        Obx(() => _buildSwitchTile(
          icon: Icons.fingerprint_rounded, 
          title: 'Enable Biometric', 
          value: controller.isBiometricEnabled.value,
          onChanged: (val) => controller.isBiometricEnabled.value = val,
        )),
      ],
    );
  }

  Widget _buildDataBackupSection(BuildContext context) {
    return _buildSectionLayout(
      'Data & Backup',
      [
        _buildControlTile(
          icon: Icons.file_download_outlined, 
          title: 'Export Transactions', 
          onTap: () => Get.toNamed(RouteHelper.getDataBackupRoute()),
        ),
        _buildControlTile(
          icon: Icons.delete_outline_rounded, 
          title: 'Clear Cache', 
          onTap: () => controller.clearCache(context),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSectionLayout(
      'Support & About',
      [
        _buildControlTile(
          icon: Icons.help_outline_rounded, 
          title: 'Help & FAQ', 
          onTap: () => Get.toNamed(RouteHelper.getFaqRoute()),
        ),
        _buildControlTile(
          icon: Icons.chat_bubble_outline_rounded, 
          title: 'Contact Us', 
          onTap: () => Get.toNamed(RouteHelper.getContactUsRoute()),
        ),
        _buildControlTile(
          icon: Icons.description_outlined, 
          title: 'Terms & Privacy', 
          onTap: () => Get.toNamed(RouteHelper.getTermsRoute()),
        ),
        _buildControlTile(
          icon: Icons.info_outline_rounded, 
          title: 'App Version', 
          trailing: Obx(() => Text(controller.appVersion.value, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => controller.logout(context),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSectionLayout(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;
              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    Divider(height: 1, indent: 70, color: Colors.grey.shade100),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildControlTile({required IconData icon, required String title, Widget? trailing, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.grey.shade700, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.grey.shade700, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryColor,
      ),
    );
  }

  void _showLanguageDialog(SettingsController controller) {
    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
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
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Select Language',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: controller.languages.length,
                  itemBuilder: (context, index) {
                    return _buildLangTile(controller, controller.languages[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildLangTile(SettingsController controller, Language lang) {
    return Obx(() {
      final isSelected = controller.selectedLanguage.value == lang.name;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: () => controller.updateLanguage(lang),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                lang.symbol,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.primaryColor,
                ),
              ),
            ),
          ),
          title: Text(
            lang.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.primaryColor : AppColors.slate800,
            ),
          ),
          subtitle: Text(
            lang.nativeName,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primaryColor.withOpacity(0.7) : Colors.grey.shade500,
            ),
          ),
          trailing: isSelected
              ? Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                )
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
    });
  }
}
