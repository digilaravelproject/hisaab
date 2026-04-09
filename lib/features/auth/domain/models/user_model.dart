import 'dart:convert';

class UserSettings {
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool pinSet;
  final String? dailyReminderTime;
  final double? weeklyBudgetLimit;
  final double? monthlyBudgetLimit;

  UserSettings({
    this.notificationsEnabled = false,
    this.biometricEnabled = false,
    this.pinSet = false,
    this.dailyReminderTime,
    this.weeklyBudgetLimit,
    this.monthlyBudgetLimit,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
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

  Map<String, dynamic> toJson() => {
        'notifications_enabled': notificationsEnabled,
        'biometric_enabled': biometricEnabled,
        'pin_set': pinSet,
        'daily_reminder_time': dailyReminderTime,
        'weekly_budget_limit': weeklyBudgetLimit,
        'monthly_budget_limit': monthlyBudgetLimit,
      };

  UserSettings copyWith({
    bool? notificationsEnabled,
    bool? biometricEnabled,
    bool? pinSet,
    String? dailyReminderTime,
    double? weeklyBudgetLimit,
    double? monthlyBudgetLimit,
  }) {
    return UserSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinSet: pinSet ?? this.pinSet,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      weeklyBudgetLimit: weeklyBudgetLimit ?? this.weeklyBudgetLimit,
      monthlyBudgetLimit: monthlyBudgetLimit ?? this.monthlyBudgetLimit,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String mobile;
  final String? email;
  final String? gender;
  final List<dynamic> userTypes;
  final String? reminderTime;
  final String? profilePhoto;
  final bool profileComplete;
  final UserSettings? settings;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.gender,
    this.userTypes = const [],
    this.reminderTime,
    this.profilePhoto,
    this.profileComplete = false,
    this.settings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'],
      gender: json['gender'],
      userTypes: json['user_types'] ?? [],
      reminderTime: json['reminder_time'],
      profilePhoto: json['profile_photo'],
      profileComplete: json['profile_complete'] ?? false,
      settings: json['settings'] != null
          ? UserSettings.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'email': email,
        'gender': gender,
        'user_types': userTypes,
        'reminder_time': reminderTime,
        'profile_photo': profilePhoto,
        'profile_complete': profileComplete,
        'settings': settings?.toJson(),
      };

  String toJsonString() => jsonEncode(toJson());

  static UserModel? fromJsonString(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
    String? gender,
    List<dynamic>? userTypes,
    String? reminderTime,
    String? profilePhoto,
    bool? profileComplete,
    UserSettings? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      userTypes: userTypes ?? this.userTypes,
      reminderTime: reminderTime ?? this.reminderTime,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      profileComplete: profileComplete ?? this.profileComplete,
      settings: settings ?? this.settings,
    );
  }
}
