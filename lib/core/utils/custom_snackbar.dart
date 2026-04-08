import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

/*class CustomSnackbar {
  /// Generic method so all snackbar styles are consistent
  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? textColor,
  }) {
    // Auto-adjust text color for readability
    final Color effectiveTextColor =
        textColor ?? (backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);

    // Using a more stable check to prevent LateInitializationError
    try {
      if (Get.isSnackbarOpen) {
        // Only attempt to close if we are certain it's initialized
        Get.closeCurrentSnackbar();
      }
    } catch (e) {
      debugPrint('Snackbar close error: $e');
    }

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: effectiveTextColor,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      icon: Icon(icon, color: effectiveTextColor),
      shouldIconPulse: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  static void showSuccess(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.successColor,
      icon: Icons.check_circle,
    );
  }

  static void showError(String message, {String title = 'Error'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.errorColor,
      icon: Icons.error,
    );
  }

  static void showInfo(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.infoColor,
      icon: Icons.info,
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.warningColor,
      icon: Icons.warning,
    );
  }
}*/



class CustomSnackbar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? textColor,
  }) {
    final Color effectiveTextColor =
        textColor ??
            (backgroundColor.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: effectiveTextColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title.toUpperCase(), fontSize: 12, fontWeight: FontWeight.bold, color: effectiveTextColor),
                AppText(message, fontSize: 13, color: effectiveTextColor),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );

    messengerKey.currentState?.hideCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(snackBar);
  }

  static void showSuccess(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.successColor,
      icon: Icons.check_circle_rounded,
    );
  }

  static void showError(String message, {String title = 'Error'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.errorColor,
      icon: Icons.error_rounded,
    );
  }

  static void showInfo(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.infoColor,
      icon: Icons.info_rounded,
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.warningColor,
      icon: Icons.warning_rounded,
    );
  }
}






class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool isHtml;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;

  const AppText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.isHtml = false,
        this.fontSize,
        this.fontWeight,
        this.fontStyle,
        this.color,
        this.letterSpacing,
        this.height,
        this.decoration,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If a full style is provided, we merge it with Poppins.
    // Otherwise, we use the individual parameters.
    final baseStyle = style ?? TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );

    return Text(
      text.tr, // .tr is idempotent if already translated
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: baseStyle,
    );
  }
}

