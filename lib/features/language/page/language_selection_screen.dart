import 'package:flutter/material.dart';
import 'package:credit_debit/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:credit_debit/core/models/language_model.dart';

import '../../auth/screens/login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LanguageController controller = Get.put(LanguageController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// Header
              Row(
                children: [
                   Text(
                    "Select Language",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose your preferred language to continue",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.slate500,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Grid
              Expanded(
                child: GridView.builder(
                  itemCount: controller.languages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.1, // Increased to make cards shorter
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final language = controller.languages[index];

                    return Obx(() {
                      final isSelected =
                          controller.selectedLanguage.value ==
                              language.code;

                      return GestureDetector(
                        onTap: () =>
                            controller.selectLanguage(language.code),
                        child: AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    .withOpacity(0.08)
                                    : Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset:
                                const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              /// Symbol Box
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primaryColor : Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    language.symbol,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// Name
                              Text(
                                language.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? AppColors.primaryColor : const Color(0xFF4A5B7A),
                                ),
                              ),

                              const SizedBox(height: 2),

                              /// Native Name
                              Text(
                                language.nativeName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? AppColors.primaryColor.withOpacity(0.8) : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              /// Next Button
              Obx(() {
                final isEnabled =
                    controller.selectedLanguage.value.isNotEmpty;

                return Container(
                  width: double.infinity,
                  margin:
                  const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                      Get.to(
                              () =>  LoginScreen());
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primaryColor,
                      minimumSize:
                      const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      disabledBackgroundColor:
                      Colors.grey.shade300,
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controller
class LanguageController extends GetxController {
  RxString selectedLanguage = ''.obs;

  void selectLanguage(String code) {
    selectedLanguage.value = code;
  }

  final List<Language> languages = [
    Language(code: 'en', name: 'English', nativeName: 'English', symbol: 'A'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', symbol: 'अ'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी', symbol: 'म'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', symbol: 'ક'),
    Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', symbol: 'த'),
    Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', symbol: 'తె'),
    Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', symbol: 'ಕ'),
    Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', symbol: 'म'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', symbol: 'ব'),
    Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', symbol: 'ਪ'),
    Language(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', symbol: 'ଓ'),
    Language(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া', symbol: 'অ'),
  ];
}
