class DashboardModel {
  final double totalBalance;
  final double income;
  final double expense;
  final double net;
  final TodayActivityModel todayActivity;
  final List<WeeklyBudgetModel> weeklyBudget;

  DashboardModel({
    required this.totalBalance,
    required this.income,
    required this.expense,
    required this.net,
    required this.todayActivity,
    required this.weeklyBudget,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalBalance: (json['total_balance'] ?? 0).toDouble(),
      income: (json['income'] ?? 0).toDouble(),
      expense: (json['expense'] ?? 0).toDouble(),
      net: (json['net'] ?? 0).toDouble(),
      todayActivity: TodayActivityModel.fromJson(json['today_activity'] ?? {}),
      weeklyBudget: (json['weekly_budget'] as List? ?? [])
          .map((v) => WeeklyBudgetModel.fromJson(v))
          .toList(),
    );
  }
}

class TodayActivityModel {
  final double credit;
  final double debit;

  TodayActivityModel({required this.credit, required this.debit});

  factory TodayActivityModel.fromJson(Map<String, dynamic> json) {
    return TodayActivityModel(
      credit: (json['credit'] ?? 0).toDouble(),
      debit: (json['debit'] ?? 0).toDouble(),
    );
  }
}

class WeeklyBudgetModel {
  final int categoryId;
  final String categoryName;
  final double weeklyBudget;
  final double weeklySpent;
  final double percentage;

  WeeklyBudgetModel({
    required this.categoryId,
    required this.categoryName,
    required this.weeklyBudget,
    required this.weeklySpent,
    required this.percentage,
  });

  factory WeeklyBudgetModel.fromJson(Map<String, dynamic> json) {
    return WeeklyBudgetModel(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? 'Unknown',
      weeklyBudget: (json['weekly_budget'] ?? 0).toDouble(),
      weeklySpent: (json['weekly_spent'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}
