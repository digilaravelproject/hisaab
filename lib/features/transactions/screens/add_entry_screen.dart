import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/category_controller.dart';
import '../domain/models/category_model.dart';

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
  CategoryModel? selectedCategory;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController(text: 'Cash');

  String _selectedSource = 'cash'; // API value
  final Map<String, String> _sourceOptions = {
    'Bank': 'bank',
    'UPI': 'upi',
    'Cash': 'cash',
  };

  String _selectedTransactionType = 'debit';
  final Map<String, String> _typeOptions = {
    'Credit': 'credit',
    'Debit': 'debit',
  };

  final List<String> businesses = ['Personal','Business'];

  List<String> get availableCategories {
    final controller = Get.find<TransactionController>();
    return controller.categories.where((c) => c != 'All').toList();
  }

  IconData _getCategoryIcon(String? iconName) {
    if (iconName == null) return Icons.category_outlined;
    final name = iconName.toLowerCase();
    if (name.contains('business')) return Icons.business_center_rounded;
    if (name.contains('food')) return Icons.restaurant_rounded;
    if (name.contains('salary')) return Icons.payments_rounded;
    if (name.contains('shopping')) return Icons.shopping_bag_rounded;
    if (name.contains('transport')) return Icons.directions_car_rounded;
    return Icons.category_outlined;
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
      
      final categoryController = Get.find<CategoryController>();
      final cats = categoryController.categories;
      selectedCategory = cats.firstWhereOrNull((c) => c.name == editingTransaction!.category);
      
      final businessVal = editingTransaction!.scope == TransactionScope.business ? 'City Shop' : 'Personal';
      if (businesses.contains(businessVal)) {
        selectedBusiness = businessVal;
      }
      _selectedTransactionType = editingTransaction!.isCredit ? 'credit' : 'debit';
    } else {
      _selectedTransactionType = entryType == 'Income' ? 'credit' : 'debit';
      // Initial defaults will be handled in build/listener if categories fetch later
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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                decoration: const InputDecoration(
                  prefixText: '₹',
                  prefixStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                  hintText: '0.00',
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'Invalid amount';
                  return null;
                },
              ),
              const Divider(height: 32),

              // Transaction Type Selector
              _buildLabel('Type'),
              InkWell(
                onTap: () => _showTypePicker(),
                child: InputDecorator(
                  decoration: _inputDecoration(Icons.swap_vert_rounded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_typeOptions.entries.firstWhere((e) => e.value == _selectedTransactionType).key),
                      const Icon(Icons.expand_more_rounded, color: AppColors.slate400, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('Category'),
              GetX<CategoryController>(
                builder: (controller) {
                  final allCats = controller.categories;
                  
                  if (selectedCategory == null && allCats.isNotEmpty) {
                    Future.microtask(() {
                      setState(() {
                        selectedCategory = allCats.first;
                      });
                    });
                  }

                  return InkWell(
                    onTap: () => _showCategoryPicker(allCats),
                    child: InputDecorator(
                      decoration: _inputDecoration(Icons.category_outlined),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (selectedCategory != null)
                            Row(
                              children: [
                                Icon(_getCategoryIcon(selectedCategory!.icon), size: 20, color: AppColors.primaryColor),
                                const SizedBox(width: 10),
                                Text(selectedCategory!.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            )
                          else
                            Text(controller.isLoading.value ? 'Loading...' : 'Select Category'),
                          const Icon(Icons.expand_more_rounded, color: AppColors.slate400, size: 20),
                        ],
                      ),
                    ),
                  );
                },
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

              // Source Selector (Conditional)
              if (entryType != 'Cash Entry') ...[
                _buildLabel('Source'),
                InkWell(
                  onTap: () => _showSourcePicker(),
                  child: InputDecorator(
                    decoration: _inputDecoration(Icons.account_balance_wallet_rounded),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_sourceController.text),
                        const Icon(Icons.expand_more_rounded, color: AppColors.slate400, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Business Selector (Conditional)
              if (entryType != 'Cash Entry') ...[
                _buildLabel('Select Business'),
                InkWell(
                  onTap: () => _showBusinessPicker(),
                  child: InputDecorator(
                    decoration: _inputDecoration(Icons.storefront_rounded),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedBusiness ?? 'Select Business/Personal'),
                        const Icon(Icons.expand_more_rounded, color: AppColors.slate400, size: 20),
                      ],
                    ),
                  ),
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
              Obx(() {
                final transactionController = Get.find<TransactionController>();
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: transactionController.isSaving.value ? null : _saveEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: transactionController.isSaving.value
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save Entry', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                );
              }),
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

  void _showTypePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text(
                'Select Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800),
              ),
            ),
            ..._typeOptions.entries.map(
              (entry) => ListTile(
                leading: Icon(
                  entry.value == 'credit' ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
                  color: _selectedTransactionType == entry.value ? AppColors.primaryColor : AppColors.slate500,
                ),
                title: Text(
                  entry.key,
                  style: TextStyle(
                    fontWeight: _selectedTransactionType == entry.value ? FontWeight.bold : FontWeight.normal,
                    color: _selectedTransactionType == entry.value ? AppColors.primaryColor : AppColors.slate800,
                  ),
                ),
                trailing: _selectedTransactionType == entry.value
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedTransactionType = entry.value;
                    selectedCategory = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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

  void _showSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text(
                'Select Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800),
              ),
            ),
            ..._sourceOptions.entries.map(
              (entry) => ListTile(
                leading: Icon(
                  entry.key == 'Bank' ? Icons.account_balance_rounded :
                  entry.key == 'UPI' ? Icons.qr_code_2_rounded :
                  Icons.money_rounded,
                  color: _selectedSource == entry.value ? AppColors.primaryColor : AppColors.slate500,
                ),
                title: Text(
                  entry.key,
                  style: TextStyle(
                    fontWeight: _selectedSource == entry.value ? FontWeight.bold : FontWeight.normal,
                    color: _selectedSource == entry.value ? AppColors.primaryColor : AppColors.slate800,
                  ),
                ),
                trailing: _selectedSource == entry.value
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedSource = entry.value;
                    _sourceController.text = entry.key;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategory == null) {
        CustomSnackbar.showError('Please select a category');
        return;
      }

      final controller = Get.find<TransactionController>();

      // Mapping business names to IDs (fallback to 1)
      int businessId = 1;
      if (selectedBusiness == 'City Shop') businessId = 2;
      if (selectedBusiness == 'Personal') businessId = 3;

      // Mapping for Source and Type as requested
      String source = _selectedSource;
      String type = _selectedTransactionType;
      
      if (entryType == 'Cash Entry') {
        // Cash Entry (force source to cash)
        source = "cash";
      }

      final Map<String, dynamic> data = {
        "type": type,
        "source": source,
        "amount": double.parse(_amountController.text),
        "transaction_date": DateFormat('yyyy-MM-dd').format(selectedDate),
        "bank_account_id": "",
        "reference_no": "",
        "category_id": selectedCategory!.id,
        "business_id": businessId,
        "description": _noteController.text.isNotEmpty ? _noteController.text : entryType,
      };

      final bool success;
      if (editingTransaction != null) {
        success = await controller.updateTransaction(editingTransaction!.id, data);
      } else {
        success = await controller.addTransaction(data);
      }

      if (success) {
        Get.back();
      }
    }
  }

  void _showCategoryPicker(List<CategoryModel> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text(
                'Select Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final c = categories[index];
                  final isSelected = selectedCategory?.id == c.id;
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getCategoryIcon(c.icon), size: 20, color: isSelected ? AppColors.primaryColor : AppColors.slate500),
                    ),
                    title: Text(
                      c.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primaryColor : AppColors.slate800,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor)
                        : null,
                    onTap: () {
                      setState(() => selectedCategory = c);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showBusinessPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text(
                'Select Business',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.slate800),
              ),
            ),
            ...businesses.map(
              (b) => ListTile(
                leading: Icon(
                  b == 'Personal' ? Icons.person_rounded : Icons.storefront_rounded,
                  color: selectedBusiness == b ? AppColors.primaryColor : AppColors.slate500,
                ),
                title: Text(
                  b,
                  style: TextStyle(
                    fontWeight: selectedBusiness == b ? FontWeight.bold : FontWeight.normal,
                    color: selectedBusiness == b ? AppColors.primaryColor : AppColors.slate800,
                  ),
                ),
                trailing: selectedBusiness == b
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor)
                    : null,
                onTap: () {
                  setState(() => selectedBusiness = b);
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
