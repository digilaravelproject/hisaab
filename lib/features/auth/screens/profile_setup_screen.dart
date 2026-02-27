import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/route_helper.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _languageController = TextEditingController();
  final _timeController = TextEditingController();
  
  TimeOfDay? _selectedTime;
  String? _selectedLanguage;

  final List<String> _languages = [
    'English',
    'Hindi',
    'Marathi',
    'Gujarati',
    'Tamil',
    'Telugu',
    'Kannada',
    'Malayalam',
    'Bengali',
    'Punjabi',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _languageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.textColorPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Language',
                style: Styles.headingStyle(context),
              ),
              SizedBox(height: Dimensions.height10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_languages[index]),
                      onTap: () {
                        setState(() {
                          _selectedLanguage = _languages[index];
                          _languageController.text = _selectedLanguage!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColorPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Profile Setup',
          style: Styles.headingStyle(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Dimensions.height20),
              
              // Form Card with decoration
              Container(
                padding: EdgeInsets.all(Dimensions.height20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: Styles.subHeadingStyle(context),
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        controller: _nameController,
                        decoration: Styles.inputDecoration(
                          context,
                          hintText: 'Enter your full name',
                          prefixIcon: Icon(Icons.person_outline, color: colorScheme.primary),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: Dimensions.height20),
                      
                      Text(
                        'Preferred Language',
                        style: Styles.subHeadingStyle(context),
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        controller: _languageController,
                        readOnly: true,
                        onTap: _showLanguagePicker,
                        decoration: Styles.inputDecoration(
                          context,
                          hintText: 'Select Language',
                          prefixIcon: Icon(Icons.language, color: colorScheme.primary),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a language';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: Dimensions.height20),
                      
                      Text(
                        'Daily Reminder Time',
                        style: Styles.subHeadingStyle(context),
                      ),
                      SizedBox(height: Dimensions.height10),
                      TextFormField(
                        controller: _timeController,
                        readOnly: true,
                        onTap: () => _selectTime(context),
                        decoration: Styles.inputDecoration(
                          context,
                          hintText: 'Pick a time',
                          prefixIcon: Icon(Icons.access_time, color: colorScheme.primary),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please pick a reminder time';
                          }
                          return null;
                        },
                      ),
                      
                      SizedBox(height: Dimensions.height30),
                      
                      CustomButton(
                        text: 'Continue',
                        onPressed: () {
                          // Proceed to Dashboard without showing snackbar here to avoid "No Overlay" error
                          // during full navigation clearing the stack.
                          Get.offAllNamed(RouteHelper.getHomeRoute());
                        },
                      ),
                    ],
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
