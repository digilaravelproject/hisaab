import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../controllers/auth_controller.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({Key? key}) : super(key: key);

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  final AuthController _authController = Get.find<AuthController>();

  // Selected API keys (lowercase as API expects)
  final List<String> _selectedKeys = [];

  final List<Map<String, String>> _userRoles = [
    {'title': 'Employee',      'key': 'employee',      'image': 'assets/images/role_employee.png'},
    {'title': 'Farmer',        'key': 'farmer',        'image': 'assets/images/role_farmer.png'},
    {'title': 'Proprietor',    'key': 'proprietor',    'image': 'assets/images/role_proprietor.png'},
    {'title': 'Business Owner','key': 'business_owner','image': 'assets/images/role_business.png'},
    {'title': 'Shopkeeper',    'key': 'shopkeeper',    'image': 'assets/images/role_shopkeeper.png'},
    {'title': 'Transporter',   'key': 'transporter',   'image': 'assets/images/role_transporter.png'},
  ];

  void _toggleRole(String key) {
    setState(() {
      if (_selectedKeys.contains(key)) {
        _selectedKeys.remove(key);
      } else {
        _selectedKeys.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Choose Role',
                style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your profession to get started',
                style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              // Role grid
              Expanded(
                child: GridView.builder(
                  itemCount: _userRoles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemBuilder: (context, index) {
                    final role = _userRoles[index];
                    final isSelected = _selectedKeys.contains(role['key']);
                    return GestureDetector(
                      onTap: () => _toggleRole(role['key']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: isSelected
                              ? Border.all(color: AppColors.primaryColor, width: 2)
                              : Border.all(color: Colors.transparent),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColors.primaryColor.withOpacity(0.15)
                                  : Colors.black.withOpacity(0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    role['image']!,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    role['title']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textColorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Checkmark badge
                            if (isSelected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Continue button
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_selectedKeys.isNotEmpty &&
                            !_authController.isLoading.value)
                        ? () => _authController.updateUserTypes(_selectedKeys)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: AppColors.primaryColor,
                      disabledBackgroundColor:
                          AppColors.primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _authController.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Continue',
                            style:
                                AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
