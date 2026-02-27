import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/route_helper.dart';
import '../../auth/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Attempt to find the controller if it exists, but don't force it for now to avoid errors if not registered
    final AuthController? authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.height15),
                _buildHeader(authController),
                SizedBox(height: Dimensions.height20),
                _buildBalanceCard(),
                SizedBox(height: Dimensions.height20),
                _buildTodaySummary(),
                SizedBox(height: Dimensions.height20),
                _buildQuickActions(context),
                SizedBox(height: Dimensions.height20),
                _buildBusinessOverview(),
                SizedBox(height: Dimensions.height20),
                _buildMonthlyExpenseChart(context),
                SizedBox(height: Dimensions.height30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AuthController? authController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Use conditional Obx only if controller and user exist
              authController != null 
                ? Obx(() => Text(
                    authController.currentUser.value?.name ?? 'Alexander',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ))
                : const Text(
                    'Alexander',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2), width: 2),
          ),
          child: const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFFE2E8F0),
            child: Icon(Icons.person, color: Color(0xFF64748B)),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A6F), Color(0xFF3949AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A6F).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'USD',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),
          const Text(
            '12,480.00',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white54, size: 16),
              const SizedBox(width: 6),
              Text(
                '**** **** **** 4296',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryItem(
            title: 'Earnings',
            amount: '+2,450',
            icon: Icons.arrow_downward,
            color: const Color(0xFF10B981),
            bgColor: const Color(0xFFECFDF5),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildSummaryItem(
            title: 'Spending',
            amount: '-1120',
            icon: Icons.arrow_upward,
            color: const Color(0xFFEF4444),
            bgColor: const Color(0xFFFEF2F2),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'title': 'Add Cash', 'icon': Icons.add_circle_outline, 'color': const Color(0xFF6366F1), 'route': RouteHelper.getBankLinkRoute()},
      {'title': 'Add Biz', 'icon': Icons.business_center_outlined, 'color': const Color(0xFFF59E0B), 'route': null},
      {'title': 'Reports', 'icon': Icons.bar_chart_outlined, 'color': const Color(0xFF10B981), 'route': null},
      {'title': 'Budget', 'icon': Icons.pie_chart_outline, 'color': const Color(0xFFEC4899), 'route': null},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        SizedBox(height: Dimensions.height15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((action) => _buildActionIcon(
            action['title'] as String,
            action['icon'] as IconData,
            action['color'] as Color,
            onTap: action['route'] != null ? () => Get.toNamed(action['route'] as String) : null,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionIcon(String title, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Business Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildBusinessCard(
                name: 'My Farm',
                profit: '+12.4%',
                isProfit: true,
                icon: Icons.agriculture,
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 15),
              _buildBusinessCard(
                name: 'My Shop',
                profit: '-2.1%',
                isProfit: false,
                icon: Icons.storefront,
                color: const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 15),
              _buildBusinessCard(
                name: 'Rentals',
                profit: '+8.5%',
                isProfit: true,
                icon: Icons.home_work_outlined,
                color: const Color(0xFF6366F1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessCard({
    required String name,
    required String profit,
    required bool isProfit,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                isProfit ? Icons.trending_up : Icons.trending_down,
                color: isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                profit,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isProfit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyExpenseChart(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Expense Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              const SizedBox(
                height: 120,
                width: 120,
                child: CustomPieChart(
                  data: [0.4, 0.25, 0.2, 0.15],
                  colors: [
                    Color(0xFF6366F1), // Shopping
                    Color(0xFFF59E0B), // Food
                    Color(0xFF10B981), // Rent
                    Color(0xFFEC4899), // Others
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildChartLegend('Shopping', '40%', const Color(0xFF6366F1)),
                    _buildChartLegend('Food', '25%', const Color(0xFFF59E0B)),
                    _buildChartLegend('Rent', '20%', const Color(0xFF10B981)),
                    _buildChartLegend('Others', '15%', const Color(0xFFEC4899)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const Spacer(),
          Text(
            percent,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  final List<double> data;
  final List<Color> colors;

  const CustomPieChart({
    Key? key,
    required this.data,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PieChartPainter(data, colors),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> colors;

  PieChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    
    double startAngle = -pi / 2;
    
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    
    canvas.drawCircle(center, radius - 7.5, bgPaint);

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = data[i] * 2 * pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 7.5),
        startAngle + 0.05,
        sweepAngle - 0.1,
        false,
        paint,
      );
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
