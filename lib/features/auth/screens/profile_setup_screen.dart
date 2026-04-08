import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/app_validators.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/hexagon_painter.dart';
import '../controllers/auth_controller.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _timeController = TextEditingController();

  TimeOfDay? _selectedTime;
  String? _selectedGender;
  late AnimationController _animationController;

  // Gender options - display label : API value
  final Map<String, String> _genderOptions = {
    'Male': 'male',
    'Female': 'female',
    'Other': 'other',
  };

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
    _nameController.dispose();
    _genderController.dispose();
    _timeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textColorPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Gender', style: Styles.headingStyle(context)),
            SizedBox(height: Dimensions.height10),
            ..._genderOptions.entries.map(
              (entry) => ListTile(
                title: Text(entry.key),
                trailing: _selectedGender == entry.value
                    ? const Icon(Icons.check, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedGender = entry.value; // API value e.g. 'male'
                    _genderController.text = entry.key; // Display label
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Converts TimeOfDay to HH:mm string (API format)
  String _formatTimeForApi(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _authController.updateProfile(
      name: _nameController.text.trim(),
      gender: _selectedGender!, // lowercase API value
      reminderTime: _formatTimeForApi(_selectedTime!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Top decorative circle
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

            // Rotating hexagon
            Positioned(
              bottom: -50,
              right: -80,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (_, child) => Transform.rotate(
                  angle: _animationController.value * 2 * math.pi,
                  child: child,
                ),
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
                padding: EdgeInsets.all(Dimensions.height20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
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
                    ),

                    const SizedBox(height: 40),

                    Text(
                      'Profile Setup',
                      style:
                          AppTextTheme.lightTextTheme.displayMedium?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tell us a bit about yourself',
                      style: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name
                          Text('Full Name', style: Styles.subHeadingStyle(context)),
                          SizedBox(height: Dimensions.height10),
                          _buildTextField(
                            controller: _nameController,
                            label: 'Enter your full name',
                            icon: Icons.person_outline,
                            validator: (v) => AppValidators.name(v, fieldName: 'Full Name'),
                          ),

                          SizedBox(height: Dimensions.height20),

                          // Gender
                          Text('Gender', style: Styles.subHeadingStyle(context)),
                          SizedBox(height: Dimensions.height10),
                          _buildTextField(
                            controller: _genderController,
                            label: 'Select Gender',
                            icon: Icons.wc_outlined,
                            readOnly: true,
                            onTap: _showGenderPicker,
                            suffixIcon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey),
                            validator: (v) =>
                                AppValidators.dropdown(_selectedGender,
                                    fieldName: 'Gender'),
                          ),

                          SizedBox(height: Dimensions.height20),

                          // Reminder Time
                          Text('Daily Reminder Time',
                              style: Styles.subHeadingStyle(context)),
                          SizedBox(height: Dimensions.height10),
                          _buildTextField(
                            controller: _timeController,
                            label: 'Pick a time',
                            icon: Icons.access_time,
                            readOnly: true,
                            onTap: () => _selectTime(context),
                            validator: (v) => AppValidators.required(v,
                                fieldName: 'Reminder Time'),
                          ),

                          SizedBox(height: Dimensions.height30),

                          // Continue button
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _authController.isLoading.value
                                    ? null
                                    : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  disabledBackgroundColor:
                                      AppColors.primaryColor.withOpacity(0.6),
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
                                        style: AppTextTheme
                                            .lightTextTheme.displayMedium
                                            ?.copyWith(
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primaryColor, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
