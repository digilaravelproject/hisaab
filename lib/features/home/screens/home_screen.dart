import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/route_helper.dart';
import '../../../core/utils/transaction_helper.dart';
import '../../../core/utils/transaction_action_sheet.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../transactions/controllers/transaction_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TransactionController transactionController = Get.find<TransactionController>();
  bool isPersonal = true; // Selected toggle state
  
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      transactionController.loadDashboardData(isBusiness: false),
      transactionController.loadDashboardData(isBusiness: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // Attempt to find the controller if it exists, to greet the user by name
    final AuthController? authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (transactionController.isLoading.value && transactionController.allTransactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => transactionController.loadTransactions(isRefresh: true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopAppBar(authController),
                  SizedBox(height: Dimensions.height15),
                  _buildSegmentedToggle(),
                  SizedBox(height: Dimensions.height20),
                  
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                    child: Column(
                      children: [
                        _buildTotalBalanceCard(),
                        SizedBox(height: Dimensions.height20),
                        _buildTodaySummaryCard(),
                        SizedBox(height: Dimensions.height20),
                        _buildWeeklyBudgetCard(),
                        SizedBox(height: Dimensions.height20),
                        _buildRecentTransactions(),
                        const SizedBox(height: 100), // Padding to clear the bottom nav bar / FAB
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // 1️⃣ Top App Bar Section
  Widget _buildTopAppBar(AuthController? authController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20, vertical: Dimensions.height15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                authController != null 
                  ? Obx(() => Text(
                      authController.currentUser.value?.name ?? 'Firoz Mohammad',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate800,
                      ),
                    ))
                  : const Text(
                      'Firoz Mohammad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate800,
                      ),
                    ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.slate800, size: 24),
                onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => Get.find<DashboardController>().changeIndex(3),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.slate100,
                  child: Icon(Icons.person, color: AppColors.slate500, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  // 2️⃣ Personal / Business Toggle
  Widget _buildSegmentedToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => isPersonal = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isPersonal ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isPersonal 
                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] 
                      : null,
                  ),
                  child: Center(
                    child: Text(
                      'Personal',
                      style: TextStyle(
                        fontWeight: isPersonal ? FontWeight.bold : FontWeight.w500,
                        color: isPersonal ? AppColors.slate800 : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() => isPersonal = false);
                  if (transactionController.businessDashboard.value == null) {
                    transactionController.loadDashboardData(isBusiness: true);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !isPersonal ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: !isPersonal 
                      ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] 
                      : null,
                  ),
                  child: Center(
                    child: Text(
                      'Business',
                      style: TextStyle(
                        fontWeight: !isPersonal ? FontWeight.bold : FontWeight.w500,
                        color: !isPersonal ? AppColors.slate800 : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3️⃣ Total Balance Card (Hero Section)
  Widget _buildTotalBalanceCard() {
    return Obx(() {
      final dashboard = isPersonal 
          ? transactionController.personalDashboard.value 
          : transactionController.businessDashboard.value;
      
      if (dashboard == null) {
        return _buildBalancePlaceholder();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(Dimensions.height20),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Text(
              '₹ ${NumberFormat('#,##,###').format(dashboard.totalBalance)}',
              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Income', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text('₹ ${NumberFormat('#,##,###').format(dashboard.income)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Expense', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text('₹ ${NumberFormat('#,##,###').format(dashboard.expense)}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Net', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text('₹ ${NumberFormat('#,##,###').format(dashboard.net)}', style: const TextStyle(color: AppColors.emerald300, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBalancePlaceholder() {
    return Container(
      width: double.infinity,
      height: 140,
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(16)),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  // 4️⃣ Today Summary Card
  Widget _buildTodaySummaryCard() {
    return Obx(() {
      final dashboard = isPersonal 
          ? transactionController.personalDashboard.value 
          : transactionController.businessDashboard.value;
      
      if (dashboard == null) return const SizedBox();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today Activity',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate800),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Credit', style: TextStyle(color: AppColors.slate500, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        '₹ ${NumberFormat('#,##,###').format(dashboard.todayActivity.credit)}',
                        style: const TextStyle(color: AppColors.emerald500, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Debit', style: TextStyle(color: AppColors.slate500, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(
                        '₹ ${NumberFormat('#,##,###').format(dashboard.todayActivity.debit)}',
                        style: const TextStyle(color: AppColors.rose500, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // 5️⃣ Weekly Budget Progress Card
  Widget _buildWeeklyBudgetCard() {
    return Obx(() {
      final dashboard = isPersonal 
          ? transactionController.personalDashboard.value 
          : transactionController.businessDashboard.value;
      
      if (dashboard == null || dashboard.weeklyBudget.isEmpty) return const SizedBox();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Budget',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.slate800),
            ),
            const SizedBox(height: 16),
            ...dashboard.weeklyBudget.map((budget) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildBudgetProgress(
                budget.categoryName, 
                budget.percentage / 100, 
                budget.percentage > 100 ? AppColors.rose500 : AppColors.primaryColor, 
                '${budget.percentage.toInt()}% spent'
              ),
            )).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildBudgetProgress(String title, double percentage, Color color, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate600)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.slate400)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
  // 6️⃣ Recent Transactions Section
  Widget _buildRecentTransactions() {
    // Explicitly grab the list to register reactivity properly in GetX Obx
    final allTxs = transactionController.allTransactions.toList();
    
    // Unify view: show top 5 from ALL transactions regardless of Personal/Business selection
    final transactions = List<TransactionModel>.from(allTxs);
    
    // Sort by date latest first and take top 5
    transactions.sort((a, b) => b.date.compareTo(a.date));
    final recentTransactions = transactions.take(5).toList();

    // Small hack: if we have NO transitions at all and we aren't loading, try one more fetch
    if (allTxs.isEmpty && !transactionController.isLoading.value) {
      Future.microtask(() => transactionController.loadTransactions());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.slate800),
            ),
            TextButton(
              onPressed: () => Get.find<DashboardController>().changeIndex(1),
              child: const Text('See All', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recentTransactions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No transactions found',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
            ),
          )
        else
          ...recentTransactions.map((tx) => _buildTransactionItem(tx)).toList(),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    return InkWell(
      onTap: () => TransactionActionSheet.show(context, tx),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                TransactionHelper.getCategoryIcon(tx.category),
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.purpose,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.slate800, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(tx.account, style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('•', style: TextStyle(color: Colors.grey))),
                      Text(
                        _formatTransactionDate(tx.date),
                        style: const TextStyle(fontSize: 12, color: AppColors.slate500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '${tx.isCredit ? "+" : "-"} ₹${tx.amount.toInt()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: tx.isCredit ? AppColors.emerald500 : AppColors.rose500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday';
    }
    return DateFormat('d MMM').format(date);
  }
}
