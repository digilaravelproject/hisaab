class BudgetStatusModel {
  final SelectedPeriodModel selectedPeriod;
  final MonthlyBudgetModel monthly;
  final List<WeekBreakdownModel> weeksBreakdown;
  final List<CategoryBreakdownModel> categoryBreakdown;

  BudgetStatusModel({
    required this.selectedPeriod,
    required this.monthly,
    required this.weeksBreakdown,
    required this.categoryBreakdown,
  });

  factory BudgetStatusModel.fromJson(Map<String, dynamic> json) {
    return BudgetStatusModel(
      selectedPeriod: SelectedPeriodModel.fromJson(json['selected_period'] as Map<String, dynamic>? ?? {}),
      monthly: MonthlyBudgetModel.fromJson(json['monthly'] as Map<String, dynamic>? ?? {}),
      weeksBreakdown: (json['weeks_breakdown'] as List? ?? [])
          .where((v) => v != null)
          .map((v) => WeekBreakdownModel.fromJson(v as Map<String, dynamic>))
          .toList(),
      categoryBreakdown: (json['category_breakdown'] as List? ?? [])
          .where((v) => v != null)
          .map((v) => CategoryBreakdownModel.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class SelectedPeriodModel {
  final int month;
  final int year;
  final String monthName;
  final String from;
  final String to;

  SelectedPeriodModel({
    required this.month,
    required this.year,
    required this.monthName,
    required this.from,
    required this.to,
  });

  factory SelectedPeriodModel.fromJson(Map<String, dynamic> json) {
    return SelectedPeriodModel(
      month: BudgetStatusModel._toInt(json['month']),
      year: BudgetStatusModel._toInt(json['year']),
      monthName: json['month_name']?.toString() ?? '',
      from: json['from']?.toString() ?? '',
      to: json['to']?.toString() ?? '',
    );
  }
}

class MonthlyBudgetModel {
  final double limit;
  final double income;
  final double spent;
  final double net;
  final double remaining;
  final double usedPercent;
  final bool isExceeded;

  MonthlyBudgetModel({
    required this.limit,
    required this.income,
    required this.spent,
    required this.net,
    required this.remaining,
    required this.usedPercent,
    required this.isExceeded,
  });

  factory MonthlyBudgetModel.fromJson(Map<String, dynamic> json) {
    return MonthlyBudgetModel(
      limit: BudgetStatusModel._toDouble(json['limit']),
      income: BudgetStatusModel._toDouble(json['income']),
      spent: BudgetStatusModel._toDouble(json['spent']),
      net: BudgetStatusModel._toDouble(json['net']),
      remaining: BudgetStatusModel._toDouble(json['remaining']),
      usedPercent: BudgetStatusModel._toDouble(json['used_percent']),
      isExceeded: json['is_exceeded'] == true || json['is_exceeded'] == 1,
    );
  }
}

class WeekBreakdownModel {
  final int weekNumber;
  final String from;
  final String to;
  final double weeklyBudget;
  final double income;
  final double spent;
  final double net;
  final double remaining;
  final double usedPercent;

  WeekBreakdownModel({
    required this.weekNumber,
    required this.from,
    required this.to,
    required this.weeklyBudget,
    required this.income,
    required this.spent,
    required this.net,
    required this.remaining,
    required this.usedPercent,
  });

  factory WeekBreakdownModel.fromJson(Map<String, dynamic> json) {
    final period = (json['period'] is Map) ? json['period'] : {};
    return WeekBreakdownModel(
      weekNumber: BudgetStatusModel._toInt(json['week_number']),
      from: period['from']?.toString() ?? '',
      to: period['to']?.toString() ?? '',
      weeklyBudget: BudgetStatusModel._toDouble(json['weekly_budget']),
      income: BudgetStatusModel._toDouble(json['income']),
      spent: BudgetStatusModel._toDouble(json['spent']),
      net: BudgetStatusModel._toDouble(json['net']),
      remaining: BudgetStatusModel._toDouble(json['remaining']),
      usedPercent: BudgetStatusModel._toDouble(json['used_percent']),
    );
  }
}

class CategoryBreakdownModel {
  final int categoryId;
  final String categoryName;
  final double weeklyBudget;
  final double weeklySpent;
  final double percentage;

  CategoryBreakdownModel({
    required this.categoryId,
    required this.categoryName,
    required this.weeklyBudget,
    required this.weeklySpent,
    required this.percentage,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      categoryId: BudgetStatusModel._toInt(json['category_id']),
      categoryName: json['category_name']?.toString() ?? '',
      weeklyBudget: BudgetStatusModel._toDouble(json['weekly_budget']),
      weeklySpent: BudgetStatusModel._toDouble(json['weekly_spent']),
      percentage: BudgetStatusModel._toDouble(json['percentage']),
    );
  }
}
