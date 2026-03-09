import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../controllers/transaction_controller.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late String entryType;
  DateTime selectedDate = DateTime.now();
  String? selectedBusiness;
  String? selectedCategory;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<String> businesses = ['My Farm', 'City Shop', 'Personal'];

  List<String> get availableCategories {
    final controller = Get.find<TransactionController>();
    return controller.categories.where((c) => c != 'All').toList();
  }

  TransactionModel? editingTransaction;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments ?? {};
    entryType = args['type'] ?? 'Expense';
    editingTransaction = args['transaction'];

    if (editingTransaction != null) {
      entryType = editingTransaction!.isCredit ? 'Income' : 'Expense';
      _amountController.text = editingTransaction!.amount.toInt().toString();
      _noteController.text = editingTransaction!.note ?? '';
      selectedDate = editingTransaction!.date;
      
      // Ensure category exists in list
      final cats = availableCategories;
      if (cats.contains(editingTransaction!.category)) {
        selectedCategory = editingTransaction!.category;
      } else {
        selectedCategory = cats.isNotEmpty ? cats.first : null;
      }
      
      final businessVal = editingTransaction!.scope == TransactionScope.business ? 'City Shop' : 'Personal';
      if (businesses.contains(businessVal)) {
        selectedBusiness = businessVal;
      }
    } else {
      if (entryType == 'Income') selectedCategory = 'Salary';
      if (entryType == 'Expense') {
        final cats = availableCategories;
        selectedCategory = cats.contains('Food') ? 'Food' : (cats.isNotEmpty ? cats.first : null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          editingTransaction != null ? 'Edit $entryType' : 'Add $entryType',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.slate800),
        ),
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.slate800,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              const Text('Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  hintText: '0.00',
                  border: InputBorder.none,
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const Divider(height: 32),

              // Category Selector
              _buildLabel('Category'),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: availableCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                decoration: _inputDecoration(Icons.category_outlined),
              ),
              const SizedBox(height: 24),

              // Date Selector
              _buildLabel('Date'),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: _inputDecoration(Icons.calendar_today_rounded),
                  child: Text(DateFormat('dd MMMM, yyyy').format(selectedDate)),
                ),
              ),
              const SizedBox(height: 24),

              // Business Selector (Conditional)
              if (entryType != 'Cash Entry') ...[
                _buildLabel('Select Business'),
                DropdownButtonFormField<String>(
                  value: selectedBusiness,
                  hint: const Text('Select Business/Personal'),
                  items: businesses.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (v) => setState(() => selectedBusiness = v),
                  decoration: _inputDecoration(Icons.storefront_rounded),
                ),
                const SizedBox(height: 24),
              ],

              // Notes
              _buildLabel('Notes'),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: _inputDecoration(Icons.notes_rounded).copyWith(hintText: 'Add a note...'),
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Save Entry', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 2),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.slate500)),
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Color _getThemeColor() => AppColors.primaryColor;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      CustomSnackbar.showSuccess(editingTransaction != null ? 'Changes saved' : '$entryType added successfully');
    }
  }
}
