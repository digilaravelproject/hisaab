import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'package:get/get.dart';

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
                  // InkWell(
                  //   onTap: () => Get.back(),
                  //   borderRadius: BorderRadius.circular(12),
                  //   child: Container(
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade100,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: const Icon(
                  //       Icons.arrow_back_ios_new_rounded,
                  //       size: 18,
                  //       color: Color(0xFF1E3A6F),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 16),
                  const Text(
                    "Select Language",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A6F),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose your preferred language",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7A99),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Grid
              Expanded(
                child: GridView.builder(
                  itemCount: controller.languages.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.85,
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
                                  ? const Color(0xFF1E3A6F)
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF1E3A6F)
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
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF1E3A6F)
                                      : Colors.grey[100],
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    language.symbol,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(
                                          0xFF1E3A6F),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              /// Name
                              Text(
                                language.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(
                                      0xFF1E3A6F)
                                      : const Color(
                                      0xFF4A5B7A),
                                ),
                              ),

                              const SizedBox(height: 2),

                              /// Native Name
                              Text(
                                language.nativeName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected
                                      ? const Color(
                                      0xFF1E3A6F)
                                      .withOpacity(0.7)
                                      : Colors.grey,
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
                      const Color(0xFF1E3A6F),
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
    Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', symbol: 'മ'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', symbol: 'ব'),
    Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', symbol: 'ਪ'),
    Language(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', symbol: 'ଓ'),
    Language(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া', symbol: 'অ'),
  ];
}

/// Model
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String symbol;

  Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.symbol,
  });
}

/// Next Screen
