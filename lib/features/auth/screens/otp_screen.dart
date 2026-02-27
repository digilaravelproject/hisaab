import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hash_code/features/auth/screens/user_selection_type_screen.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_image_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../routes/route_helper.dart';
import '../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final theme = Theme.of(context); // Theme shortcut
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        elevation: 0,
      ),
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
                    SizedBox(height: Dimensions.height20),

                    // Image
                    Center(
                      child: CustomImageWidget(
                        imagePath:  ImageConstants.otpVerification,
                        height: 150,
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Title
                    Text(
                      'OTP Verification',
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
                      'We have sent OTP to your mobile number',
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: Dimensions.font16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: Dimensions.height10),

                    // Mobile number
                    Text(
                      authController.currentMobile.value,
                      style: TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: Dimensions.height30),

                    // OTP fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                            (index) => SizedBox(
                          width: 50,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(1),
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:  BorderSide(color: colorScheme.outline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:  BorderSide(color:  colorScheme.primary, width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                // Auto-focus to next field
                                if (index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }

                                // Update OTP controller
                                String currentOtp = authController.otpController.text;
                                if (currentOtp.length <= index) {
                                  authController.otpController.text = currentOtp + value;
                                } else {
                                  String newOtp = '';
                                  for (int i = 0; i < currentOtp.length; i++) {
                                    if (i == index) {
                                      newOtp += value;
                                    } else {
                                      newOtp += currentOtp[i];
                                    }
                                  }
                                  authController.otpController.text = newOtp;
                                }
                              } else {
                                // Remove digit from OTP controller
                                String currentOtp = authController.otpController.text;
                                if (currentOtp.isNotEmpty && currentOtp.length > index) {
                                  String newOtp = '';
                                  for (int i = 0; i < currentOtp.length; i++) {
                                    if (i == index) {
                                      // Skip this digit
                                    } else {
                                      newOtp += currentOtp[i];
                                    }
                                  }
                                  authController.otpController.text = newOtp;
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: Dimensions.height30),

                    // Verify button
                    CustomButton(
                      text: 'Verify OTP',
                      onPressed: authController.verifyOtp,
                      isLoading: authController.isLoading.value,
                    ),

                    SizedBox(height: Dimensions.height20),

                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Didn\'t receive OTP? ',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: Dimensions.font14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Resend OTP logic
                            if (authController.currentUser.value?.mobile.isNotEmpty ?? false) {
                              authController.login();
                            }
                          },
                          child: Text(
                            'Resend',
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: Dimensions.font14,
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
}


class OtpScreen1 extends StatelessWidget {
  final String mobileNumber;

  const OtpScreen1({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

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

              const SizedBox(height: 30),

              // Title
              Text(
                'Verify OTP',
                style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              RichText(
                text: TextSpan(
                  text: 'Code sent to ',
                  style: AppTextTheme.lightTextTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '+91 $mobileNumber',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // OTP Boxes (4 digits only)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                      (index) => SizedBox(
                    width: 70,
                    height: 70,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        } else if (value.length == 1 && index == 3) {
                          // Auto verify when last digit entered
                          _verifyOtp(context);
                        }
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColorPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Resend Option
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: AppTextTheme.lightTextTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('OTP resent successfully'),
                            backgroundColor: AppColors.successColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                      ),
                      child: const Text(
                        'Resend',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _verifyOtp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
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

  void _verifyOtp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const UserTypeScreen(),
      ),
    );
  }
}
