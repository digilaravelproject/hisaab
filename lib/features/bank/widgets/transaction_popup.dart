import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';

enum TransactionType { credit, debit }

class TransactionPopup extends StatefulWidget {
  final double amount;
  final TransactionType type;
  final DateTime date;
  final List<String> purposes;
  final Function(String selectedPurpose) onSave;

  const TransactionPopup({
    Key? key,
    required this.amount,
    required this.type,
    required this.date,
    required this.purposes,
    required this.onSave,
  }) : super(key: key);

  static void show({
    required double amount,
    required TransactionType type,
    required DateTime date,
    required List<String> purposes,
    required Function(String) onSave,
  }) {
    Get.bottomSheet(
      TransactionPopup(
        amount: amount,
        type: type,
        date: date,
        purposes: purposes,
        onSave: onSave,
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  State<TransactionPopup> createState() => _TransactionPopupState();
}

class _TransactionPopupState extends State<TransactionPopup> {
  late String _selectedPurpose;

  @override
  void initState() {
    super.initState();
    _selectedPurpose = widget.purposes.isNotEmpty ? widget.purposes.first : 'General';
  }

  @override
  Widget build(BuildContext context) {
    bool isCredit = widget.type == TransactionType.credit;

    return Container(
      padding: EdgeInsets.all(Dimensions.height20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radius30),
          topRight: Radius.circular(Dimensions.radius30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height20),
          
          Text(
            'Transaction Detected',
            style: TextStyle(
              fontSize: Dimensions.font18,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorPrimary,
            ),
          ),
          SizedBox(height: Dimensions.height20),

          // Amount and Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${widget.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: Dimensions.font24 * 1.2,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isCredit ? AppColors.primaryColor : Colors.red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Text(
                  isCredit ? 'CREDIT' : 'DEBIT',
                  style: TextStyle(
                    color: isCredit ? AppColors.primaryColor : Colors.red,
                    fontSize: Dimensions.font12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height10),

          // Date
          Text(
            DateFormat('MMMM dd, yyyy - hh:mm a').format(widget.date),
            style: TextStyle(
              fontSize: Dimensions.font14,
              color: AppColors.textColorSecondary,
            ),
          ),
          SizedBox(height: Dimensions.height30),

          // Purpose Dropdown
          Text(
            'Select Purpose',
            style: TextStyle(
              fontSize: Dimensions.font14,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorSecondary,
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(Dimensions.radius12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPurpose,
                isExpanded: true,
                items: widget.purposes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPurpose = newValue!;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: Dimensions.height30),

          // Save Button
          SizedBox(
            width: double.infinity,
            height: Dimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(_selectedPurpose);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Transaction',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),
        ],
      ),
    );
  }
}
