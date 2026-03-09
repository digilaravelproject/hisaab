import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/image_constants.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../routes/route_helper.dart';
import '../controllers/auth_controller.dart';

import 'dart:math' as math;
import '../widget/text_field.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _mobileController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
        children: [
          // Subtle decorative shapes
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withOpacity(0.05),
              ),
            ),
          ),

          // Rotating Background Icon
          Positioned(
            bottom: -50,
            right: -80,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: SizedBox(
                width: 300,
                height: 300,
                child: CustomPaint(
                  painter: HexagonPainter(
                    color: AppColors.primaryColor.withOpacity(0.03),
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
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

              const SizedBox(height: 60),

              // Simple Icon/Logo at Top
              Center(
                child: Image.asset(
                  ImageConstants.logo,
                  height: 100,
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: Text(
                  'Welcome Back',
                  style: AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Sign in to continue',
                  style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Mobile Number Field
              CurvedTextField(
                controller: _mobileController,
                hintText: 'Enter mobile number',
                prefixIcon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              const SizedBox(height: 40),
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // if (_mobileController.text.length == 10) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen1(
                          mobileNumber: _mobileController.text,
                        ),
                      ),
                    );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Terms
              Center(
                child: Text(
                  'By continuing, you agree to our Terms & Conditions',
                  style: AppTextTheme.lightTextTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ],
    ),
    ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;

  const HexagonPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;
    
    // Draw an pointy-topped hexagon
    final centerX = width / 2;
    final centerY = height / 2;
    final radius = math.min(width, height) / 2;

    for (int i = 0; i < 6; i++) {
        final angle = (60 * i - 30) * math.pi / 180;
        final x = centerX + radius * math.cos(angle);
        final y = centerY + radius * math.sin(angle);
        if (i == 0) {
            path.moveTo(x, y);
        } else {
            path.lineTo(x, y);
        }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HexagonPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}














