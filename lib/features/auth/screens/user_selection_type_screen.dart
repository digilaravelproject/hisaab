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
  String? selectedRole;

  final List<Map<String, dynamic>> userRoles = [
    {
      'title': 'Employee',
      'icon': Icons.person_outline_rounded,
      'color': Color(0xFFE3F2FD),
      'iconColor': Color(0xFF1976D2),
    },
    {
      'title': 'Farmer',
      'icon': Icons.agriculture_rounded,
      'color': Color(0xFFE8F5E9),
      'iconColor': Color(0xFF388E3C),
    },
    {
      'title': 'Proprietor',
      'icon': Icons.business_center_rounded,
      'color': Color(0xFFFFF3E0),
      'iconColor': Color(0xFFF57C00),
    },
    {
      'title': 'Business',
      'icon': Icons.store_rounded,
      'color': Color(0xFFF3E5F5),
      'iconColor': Color(0xFF7B1FA2),
    },
    {
      'title': 'Shopkeeper',
      'icon': Icons.shop_rounded,
      'color': Color(0xFFFFEBEE),
      'iconColor': Color(0xFFC62828),
    },
    {
      'title': 'Transporter',
      'icon': Icons.local_shipping_rounded,
      'color': Color(0xFFE0F2F1),
      'iconColor': Color(0xFF00796B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.primaryColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Choose Role',
          style: AppTextTheme.lightTextTheme.displaySmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself',
              style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select your profession to get started',
              style: AppTextTheme.lightTextTheme.bodyMedium,
            ),
            const SizedBox(height: 30),
            // Grid of user types
            Expanded(
              child: GridView.builder(
                itemCount: userRoles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final role = userRoles[index];
                  final isSelected = selectedRole == role['title'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRole = role['title'];
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
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: role['color'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              role['icon'],
                              color: role['iconColor'],
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            role['title'],
                            style: const TextStyle(
                              fontSize: 16,
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
                onPressed: selectedRole != null
                    ? () {
                  Get.toNamed(RouteHelper.getProfileSetupRoute());

                  // Handle navigation with selectedRole
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$selectedRole selected!'),
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
                  'Next',
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
    );
  }
}