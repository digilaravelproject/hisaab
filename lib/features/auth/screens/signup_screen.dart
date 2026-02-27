import 'package:hash_code/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final theme = Theme.of(context); // Theme shortcut
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;


    return Scaffold(
      body: SafeArea(
        child: Obx(
              () => Stack(
            children: [


              // Content
              SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.height20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Dimensions.height45),

                    // Logo
                    Center(
                      child: Image.asset(
                        ImageConstants.logo,
                        height: 100,
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Title
                    Text(
                      'Create Account',
                      style: textTheme.headlineMedium?.copyWith(
                        fontSize: Dimensions.font24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: Dimensions.height10),

                    // Subtitle
                    Text(
                      'Enter your details to create an account',
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: Dimensions.font16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Form
                    Form(
                      key: authController.formKey,
                      child: Column(
                        children: [
                          // Name field
                          TextFormField(
                            controller: authController.nameController,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: Styles.inputDecoration(
                              context,
                              hintText: 'Full Name',
                              prefixIcon: Icon(Icons.phone_android, color: colorScheme.primary),
                            ),

                            validator: authController.validateName,
                          ),

                          SizedBox(height: Dimensions.height20),

                          // Mobile field
                          TextFormField(
                            controller: authController.mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: Styles.inputDecoration(
                              context,
                              hintText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone_android, color: colorScheme.primary),
                            ),
                            validator: authController.validateMobile,
                            maxLength: 10,
                          ),

                          SizedBox(height: Dimensions.height20),

                          // Signup button
                          CustomButton(
                            text: 'Sign Up',
                            onPressed: authController.signup,
                            isLoading: authController.isLoading.value,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontSize: Dimensions.font14,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteHelper.getLoginRoute()),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    // Profile Setup link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Want to setup profile? ',
                          style: TextStyle(
                            fontSize: Dimensions.font14,
                            color: AppColors.textColorSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(RouteHelper.getProfileSetupRoute()),
                          child: Text(
                            'Setup Profile',
                            style: TextStyle(
                              fontSize: Dimensions.font14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (authController.isLoading.value)
                LoadingWidget(type: LoadingType.overlay),
            ],
          ),
        ),
      ),
    );
  }
}
