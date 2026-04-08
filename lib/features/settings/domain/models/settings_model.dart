class SettingsModel {
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool pinSet;
  final String? dailyReminderTime; // "HH:mm:ss" or null
  final double? weeklyBudgetLimit;
  final double? monthlyBudgetLimit;

  SettingsModel({
    this.notificationsEnabled = false,
    this.biometricEnabled = false,
    this.pinSet = false,
    this.dailyReminderTime,
    this.weeklyBudgetLimit,
    this.monthlyBudgetLimit,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      notificationsEnabled: json['notifications_enabled'] ?? false,
      biometricEnabled: json['biometric_enabled'] ?? false,
      pinSet: json['pin_set'] ?? false,
      dailyReminderTime: json['daily_reminder_time'],
      weeklyBudgetLimit: json['weekly_budget_limit'] != null
          ? double.tryParse(json['weekly_budget_limit'].toString())
          : null,
      monthlyBudgetLimit: json['monthly_budget_limit'] != null
          ? double.tryParse(json['monthly_budget_limit'].toString())
          : null,
    );
  }
}
