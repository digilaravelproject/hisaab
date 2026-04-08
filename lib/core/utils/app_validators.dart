class AppValidators {
  // Regex patterns
  static final _mobileRegex = RegExp(r'^[0-9]{10}$');
  static final _emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  static final _nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");
  static final _alphaNumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
  static final _numericRegex = RegExp(r'^[0-9]+$');
  static final _decimalRegex = RegExp(r'^\d+(\.\d{1,2})?$');
  static final _panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  static final _gstRegex = RegExp(
      r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
  static final _pinCodeRegex = RegExp(r'^[1-9][0-9]{5}$');
  static final _ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
  static final _accountNumberRegex = RegExp(r'^[0-9]{9,18}$');
 /* static final _urlRegex = RegExp(
      r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:/?#\[\]@!$&\'()*+,;=]*)?$');*/
  static final _aadharRegex = RegExp(r'^[2-9]{1}[0-9]{11}$');

  // ─── Empty / Required ───────────────────────────────────────────────────────

  /// Generic required field validator
  static String? required(
    String? value, {
    String fieldName = "Field",
    String? customMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? "$fieldName is required";
    }
    return null;
  }

  // ─── Name ───────────────────────────────────────────────────────────────────

  /// Validates a person's name (letters, spaces, hyphens, apostrophes)
  static String? name(
    String? value, {
    String fieldName = "Name",
    int minLength = 2,
    int maxLength = 50,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "$fieldName is required";
    if (!_nameRegex.hasMatch(trimmed)) {
      return customMessage ?? "$fieldName can only contain letters";
    }
    if (trimmed.length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }
    if (trimmed.length > maxLength) {
      return "$fieldName must be at most $maxLength characters";
    }
    return null;
  }

  // ─── Mobile ─────────────────────────────────────────────────────────────────

  /// Validates a mobile number (default 10 digits)
  static String? mobile(
    String? value, {
    int length = 10,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "Mobile number is required";
    final pattern = RegExp(r'^[0-9]{' + length.toString() + r'}$');
    if (!pattern.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid $length-digit mobile number";
    }
    return null;
  }

  // ─── Email ──────────────────────────────────────────────────────────────────

  /// Validates an email address
  static String? email(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "Email is required";
    if (!_emailRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid email address";
    }
    return null;
  }

  // ─── Password ───────────────────────────────────────────────────────────────

  /// Validates a password with configurable rules
  static String? password(
    String? value, {
    int minLength = 6,
    int maxLength = 32,
    bool requireUppercase = false,
    bool requireNumber = false,
    bool requireSpecialChar = false,
    String? customMessage,
  }) {
    final trimmed = value ?? "";
    if (trimmed.isEmpty) return "Password is required";
    if (trimmed.length < minLength) {
      return "Password must be at least $minLength characters";
    }
    if (trimmed.length > maxLength) {
      return "Password must be at most $maxLength characters";
    }
    if (requireUppercase && !trimmed.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one uppercase letter";
    }
    if (requireNumber && !trimmed.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number";
    }
    if (requireSpecialChar &&
        !trimmed.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return "Password must contain at least one special character";
    }
    return customMessage;
  }

  /// Validates confirm password matches original
  static String? confirmPassword(
    String? value,
    String? originalPassword, {
    String? customMessage,
  }) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != originalPassword) {
      return customMessage ?? "Passwords do not match";
    }
    return null;
  }

  // ─── Amount / Number ────────────────────────────────────────────────────────

  /// Validates a numeric amount (supports decimals up to 2 places)
  static String? amount(
    String? value, {
    double? min,
    double? max,
    String fieldName = "Amount",
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "$fieldName is required";
    if (!_decimalRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid $fieldName";
    }
    final parsed = double.tryParse(trimmed);
    if (parsed == null) return "Enter a valid $fieldName";
    if (min != null && parsed < min) {
      return "$fieldName must be at least $min";
    }
    if (max != null && parsed > max) {
      return "$fieldName must not exceed $max";
    }
    return null;
  }

  /// Validates a whole number (integer only)
  static String? number(
    String? value, {
    int? min,
    int? max,
    String fieldName = "Value",
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "$fieldName is required";
    if (!_numericRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid number";
    }
    final parsed = int.tryParse(trimmed);
    if (parsed == null) return "Enter a valid number";
    if (min != null && parsed < min) return "$fieldName must be at least $min";
    if (max != null && parsed > max) return "$fieldName must not exceed $max";
    return null;
  }

  // ─── Text / Description ─────────────────────────────────────────────────────

  /// Validates a text field with min/max length
  static String? text(
    String? value, {
    String fieldName = "Field",
    int minLength = 1,
    int maxLength = 500,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "$fieldName is required";
    if (trimmed.length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }
    if (trimmed.length > maxLength) {
      return "$fieldName must not exceed $maxLength characters";
    }
    return null;
  }

  // ─── PIN / OTP ──────────────────────────────────────────────────────────────

  /// Validates a PIN code (default 4 digits)
  static String? pin(
    String? value, {
    int length = 4,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "PIN is required";
    final pattern = RegExp(r'^[0-9]{' + length.toString() + r'}$');
    if (!pattern.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid $length-digit PIN";
    }
    return null;
  }

  /// Validates an OTP (default 6 digits)
  static String? otp(
    String? value, {
    int length = 6,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "OTP is required";
    final pattern = RegExp(r'^[0-9]{' + length.toString() + r'}$');
    if (!pattern.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid $length-digit OTP";
    }
    return null;
  }

  // ─── Address / Location ─────────────────────────────────────────────────────

  /// Validates a PIN/ZIP code (6-digit Indian PIN)
  static String? pinCode(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "PIN code is required";
    if (!_pinCodeRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid 6-digit PIN code";
    }
    return null;
  }

  /// Validates an address field
  static String? address(
    String? value, {
    int minLength = 10,
    int maxLength = 200,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "Address is required";
    if (trimmed.length < minLength) {
      return "Address must be at least $minLength characters";
    }
    if (trimmed.length > maxLength) {
      return "Address must not exceed $maxLength characters";
    }
    return null;
  }

  // ─── Banking / Finance ──────────────────────────────────────────────────────

  /// Validates an IFSC code
  static String? ifsc(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim().toUpperCase() ?? "";
    if (trimmed.isEmpty) return "IFSC code is required";
    if (!_ifscRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid IFSC code";
    }
    return null;
  }

  /// Validates a bank account number (9–18 digits)
  static String? accountNumber(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "Account number is required";
    if (!_accountNumberRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid account number";
    }
    return null;
  }

  // ─── Identity Documents ─────────────────────────────────────────────────────

  /// Validates a PAN card number
  static String? pan(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim().toUpperCase() ?? "";
    if (trimmed.isEmpty) return "PAN number is required";
    if (!_panRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid PAN number (e.g. ABCDE1234F)";
    }
    return null;
  }

  /// Validates a GST number
  static String? gst(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim().toUpperCase() ?? "";
    if (trimmed.isEmpty) return "GST number is required";
    if (!_gstRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid GST number";
    }
    return null;
  }

  /// Validates an Aadhar card number (12 digits, starts with 2-9)
  static String? aadhar(
    String? value, {
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "Aadhar number is required";
    if (!_aadharRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid 12-digit Aadhar number";
    }
    return null;
  }

  // ─── URL ────────────────────────────────────────────────────────────────────

  /// Validates a URL
  // static String? url(
  //   String? value, {
  //   String? customMessage,
  // }) {
  //   final trimmed = value?.trim() ?? "";
  //   if (trimmed.isEmpty) return "URL is required";
  //   if (!_urlRegex.hasMatch(trimmed)) {
  //     return customMessage ?? "Enter a valid URL";
  //   }
  //   return null;
  // }

  // ─── Date ───────────────────────────────────────────────────────────────────

  /// Validates a date string in dd/MM/yyyy format
  static String? date(
    String? value, {
    String format = "dd/MM/yyyy",
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "Date is required";
    final parts = trimmed.split('/');
    if (parts.length != 3) return customMessage ?? "Enter date in $format";
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return customMessage ?? "Enter a valid date";
    }
    if (month < 1 || month > 12) return "Enter a valid month";
    if (day < 1 || day > 31) return "Enter a valid day";
    return null;
  }

  // ─── Dropdown / Selection ───────────────────────────────────────────────────

  /// Validates a dropdown selection (checks for null or empty string)
  static String? dropdown<T>(
    T? value, {
    String fieldName = "Field",
    String? customMessage,
  }) {
    if (value == null) return customMessage ?? "Please select a $fieldName";
    if (value is String && value.trim().isEmpty) {
      return customMessage ?? "Please select a $fieldName";
    }
    return null;
  }

  // ─── Alphanumeric ───────────────────────────────────────────────────────────

  /// Validates alphanumeric input only
  static String? alphaNumeric(
    String? value, {
    String fieldName = "Field",
    int? minLength,
    int? maxLength,
    String? customMessage,
  }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) return "$fieldName is required";
    if (!_alphaNumericRegex.hasMatch(trimmed)) {
      return customMessage ?? "$fieldName can only contain letters and numbers";
    }
    if (minLength != null && trimmed.length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }
    if (maxLength != null && trimmed.length > maxLength) {
      return "$fieldName must not exceed $maxLength characters";
    }
    return null;
  }

  // ─── Legacy aliases (backward compatibility) ────────────────────────────────

  /// @deprecated Use [required] instead
  static String? validateEmpty(
    String? value, {
    String fieldName = "Field",
    String? customMessage,
  }) =>
      required(value, fieldName: fieldName, customMessage: customMessage);

  /// @deprecated Use [mobile] instead
  static String? validateMobile(
    String? value, {
    int length = 10,
    String? customMessage,
  }) =>
      mobile(value, length: length, customMessage: customMessage);

  /// @deprecated Use [email] instead
  static String? validateEmail(
    String? value, {
    String? customMessage,
  }) =>
      email(value, customMessage: customMessage);
}
