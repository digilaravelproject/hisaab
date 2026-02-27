import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../routes/route_helper.dart';
import '../controllers/auth_controller.dart';

/*class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                      child: Image.asset(ImageConstants.logo, height: 100),
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Title
                    Text(
                      'Login',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: Dimensions.height10),

                    // Subtitle
                    Text(
                      'Enter your mobile number to continue',
                      style: textTheme.bodyMedium?.copyWith(
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
                          // Mobile field
                          TextFormField(
                            controller: authController.mobileController,
                            keyboardType: TextInputType.phone,
                            decoration: Styles.inputDecoration(
                              context,
                              hintText: 'Mobile Number',
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: colorScheme.primary,
                              ),
                            ),
                            validator: authController.validateMobile,
                            maxLength: 10,
                          ),

                          SizedBox(height: Dimensions.height20),

                          // Login button
                          CustomButton(
                            text: 'Send OTP',
                            onPressed: authController.login,
                            isLoading: authController.isLoading.value,
                            buttonType: ButtonStyleType.filled,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Signup link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              () => Get.toNamed(RouteHelper.getSignupRoute()),
                          child: Text(
                            'Sign Up',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
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
}*/






import '../widget/text_field.dart';
import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
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

              const SizedBox(height: 40),

              // Logo
              Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryColor, AppColors.secondaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Title
              Text(
                'Welcome Back!',
                style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Please enter your mobile number to continue',
                style: AppTextTheme.lightTextTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              // Mobile Number Field
              CurvedTextField(
                controller: _mobileController,
                hintText: 'Enter mobile number',
                prefixIcon: Icons.call_rounded,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    //if (_mobileController.text.length == 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OtpScreen1(
                            mobileNumber: _mobileController.text,
                          ),
                        ),
                      );
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: const Text('Please enter valid 10-digit number'),
                    //       backgroundColor: AppColors.errorColor,
                    //       behavior: SnackBarBehavior.floating,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Terms
              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Conditions',
                  style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    color: AppColors.textColorHint,
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














