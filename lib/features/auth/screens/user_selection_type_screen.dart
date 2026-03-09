import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../routes/route_helper.dart';

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({Key? key}) : super(key: key);

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  List<String> selectedRoles = [];

  final List<Map<String, dynamic>> userRoles = [
    {
      'title': 'Employee',
      'image': 'assets/images/role_employee.png',
    },
    {
      'title': 'Farmer',
      'image': 'assets/images/role_farmer.png',
    },
    {
      'title': 'Proprietor',
      'image': 'assets/images/role_proprietor.png',
    },
    {
      'title': 'Business Owner',
      'image': 'assets/images/role_business.png',
    },
    {
      'title': 'Shopkeeper',
      'image': 'assets/images/role_shopkeeper.png',
    },
    {
      'title': 'Transporter',
      'image': 'assets/images/role_transporter.png',
    },
  ];

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
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
            // Grid of user types
            Expanded(
              child: GridView.builder(
                itemCount: userRoles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final role = userRoles[index];
                  final isSelected = selectedRoles.contains(role['title']);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedRoles.contains(role['title'])) {
                          selectedRoles.remove(role['title']);
                        } else {
                          selectedRoles.add(role['title']);
                        }
                      });
                    },
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            role['image'],
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            role['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColorPrimary,
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
            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedRoles.isNotEmpty
                    ? () {
                  Get.toNamed(RouteHelper.getBankIntroRoute());

                  // Handle navigation with selectedRoles
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${selectedRoles.join(", ")} selected!'),
                      backgroundColor: AppColors.successColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.4),
                ),
                child: Text(
                  'Continue',
                  style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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