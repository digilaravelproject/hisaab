import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/business_detail_controller.dart';

class BusinessDetailScreen extends StatelessWidget {
  const BusinessDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusinessDetailController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Business Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.height20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(controller),
            SizedBox(height: Dimensions.height30),
            _buildTrendSection(controller),
            SizedBox(height: Dimensions.height30),
            _buildTransactionList(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BusinessDetailController controller) {
    return Obx(() => Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildSummaryCard('Income', '₹${controller.totalIncome.value.toStringAsFixed(0)}', Colors.green, Icons.arrow_downward)),
            SizedBox(width: Dimensions.width15),
            Expanded(child: _buildSummaryCard('Expense', '₹${controller.totalExpense.value.toStringAsFixed(0)}', Colors.red, Icons.arrow_upward)),
          ],
        ),
        SizedBox(height: Dimensions.height15),
        Container(
          padding: EdgeInsets.all(Dimensions.height20),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Net Profit', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Text('₹${controller.netProfit.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${controller.profitPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildSummaryCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(Dimensions.height15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(color: AppColors.textColorSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: AppColors.textColorPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTrendSection(BusinessDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Monthly Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: Dimensions.height20),
        Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
          ),
          child: CustomPaint(
            painter: LineChartPainter(data: controller.monthlyData),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList(BusinessDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: Dimensions.height15),
        Obx(() => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentTransactions.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey[100]),
          itemBuilder: (context, index) {
            final tx = controller.recentTransactions[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (tx.isIncome ? Colors.green : Colors.red).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(tx.isIncome ? Icons.add : Icons.remove, color: tx.isIncome ? Colors.green : Colors.red, size: 20),
              ),
              title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(tx.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              trailing: Text(
                '${tx.isIncome ? "+" : "-"} ₹${tx.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tx.isIncome ? Colors.green : Colors.red,
                ),
              ),
            );
          },
        )),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  LineChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primaryColor.withValues(alpha: 0.3), AppColors.primaryColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    double maxVal = data.fold(0, (max, e) => e > max ? e : max);
    double xStep = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      double x = i * xStep;
      double y = size.height - (data[i] / maxVal * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == data.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()..color = AppColors.primaryColor..style = PaintingStyle.fill;
    for (int i = 0; i < data.length; i++) {
        double x = i * xStep;
        double y = size.height - (data[i] / maxVal * size.height);
        canvas.drawCircle(Offset(x, y), 4, pointPaint);
        canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
