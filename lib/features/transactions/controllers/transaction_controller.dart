import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum TransactionType { income, expense, cash, bank }
enum TransactionScope { business, personal }

class TransactionModel {
  final String id;
  final String purpose;
  final double amount;
  final bool isCredit;
  final DateTime date;
  final String category;
  final String account; // Bank name or "Cash"
  final TransactionScope scope;
  final bool hasAttachment;
  final String? note;
  final bool isUncategorized;

  TransactionModel({
    required this.id,
    required this.purpose,
    required this.amount,
    required this.isCredit,
    required this.date,
    required this.category,
    required this.account,
    required this.scope,
    this.hasAttachment = false,
    this.note,
    this.isUncategorized = false,
  });
}

class TransactionController extends GetxController {
  final allTransactions = <TransactionModel>[].obs;
  final filteredTransactions = <TransactionModel>[].obs;
  
  final searchQuery = ''.obs;
  final selectedType = 'All'.obs; 
  final selectedSort = 'Latest first'.obs;
  final selectedCategory = 'All'.obs;
  final selectedAccount = 'All'.obs;
  final selectedScope = 'All'.obs; // All, Business, Personal
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Temporary states for the Filter Bottom Sheet session
  final tempType = 'All'.obs;
  final tempSort = 'Latest first'.obs;
  final tempCategory = 'All'.obs;
  final tempAccount = 'All'.obs;
  final tempScope = 'All'.obs;
  final tempStart = Rx<DateTime?>(null);
  final tempEnd = Rx<DateTime?>(null);

  final categories = <String>[].obs;
  final accounts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    _extractFilterOptions();
    applyFilters();
  }



  void initTempFilters() {
    tempType.value = selectedType.value;
    tempSort.value = selectedSort.value;
    tempCategory.value = selectedCategory.value;
    tempAccount.value = selectedAccount.value;
    tempScope.value = selectedScope.value;
    tempStart.value = startDate.value;
    tempEnd.value = endDate.value;
  }

  void commitFilters() {
    selectedType.value = tempType.value;
    selectedSort.value = tempSort.value;
    selectedCategory.value = tempCategory.value;
    selectedAccount.value = tempAccount.value;
    selectedScope.value = tempScope.value;
    startDate.value = tempStart.value;
    endDate.value = tempEnd.value;
    applyFilters();
  }

  void _extractFilterOptions() {
    final cats = allTransactions.map((tx) => tx.category).toSet().toList();
    cats.sort();
    categories.assignAll(['All', ...cats]);

    final accs = allTransactions.map((tx) => tx.account).toSet().toList();
    accs.sort();
    accounts.assignAll(['All', ...accs]);
  }

  void _loadMockData() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    
    allTransactions.assignAll([
      // Current Month Transactions
      TransactionModel(
        id: '1',
        purpose: 'Office Rent - March',
        amount: 35000.0,
        isCredit: false,
        date: now.subtract(const Duration(days: 2)),
        category: 'Rent',
        account: 'HDFC Bank',
        scope: TransactionScope.business,
        hasAttachment: true,
      ),
      TransactionModel(
        id: '2',
        purpose: 'Freelance UI Design Payment',
        amount: 55000.0,
        isCredit: true,
        date: now.subtract(const Duration(days: 1)),
        category: 'Income',
        account: 'ICICI Bank',
        scope: TransactionScope.business,
      ),
      TransactionModel(
        id: '3',
        purpose: 'Grocery Shopping - Reliance Fresh',
        amount: 4200.0,
        isCredit: false,
        date: now.subtract(const Duration(days: 3)),
        category: 'Food',
        account: 'Cash',
        scope: TransactionScope.personal,
      ),
      TransactionModel(
        id: '4',
        purpose: 'Petrol - Bharat Petroleum',
        amount: 3500.0,
        isCredit: false,
        date: now.subtract(const Duration(days: 4)),
        category: 'Transport',
        account: 'ICICI Bank',
        scope: TransactionScope.personal,
      ),
      TransactionModel(
        id: '5',
        purpose: 'Amazon - Electronics Purchase',
        amount: 12000.0,
        isCredit: false,
        date: now.subtract(const Duration(days: 5)),
        category: 'Shopping',
        account: 'HDFC Bank',
        scope: TransactionScope.business,
      ),
      TransactionModel(
        id: '6',
        purpose: 'Electricity Bill',
        amount: 2800.0,
        isCredit: false,
        date: now.subtract(const Duration(days: 10)),
        category: 'Utilities',
        account: 'HDFC Bank',
        scope: TransactionScope.personal,
      ),
      TransactionModel(
        id: '7',
        purpose: 'Gym Membership',
        amount: 1500.0,
        isCredit: false,
        date: now.subtract(const Duration(days: 12)),
        category: 'Health',
        account: 'Cash',
        scope: TransactionScope.personal,
      ),
      
      // Last Month Transactions (for comparison)
      TransactionModel(
        id: '101',
        purpose: 'Previous Month Salary',
        amount: 80000.0,
        isCredit: true,
        date: lastMonth,
        category: 'Salary',
        account: 'HDFC Bank',
        scope: TransactionScope.personal,
      ),
      TransactionModel(
        id: '102',
        purpose: 'Old Office Rent',
        amount: 35000.0,
        isCredit: false,
        date: lastMonth.subtract(const Duration(days: 5)),
        category: 'Rent',
        account: 'HDFC Bank',
        scope: TransactionScope.business,
      ),
      TransactionModel(
        id: '103',
        purpose: 'Bulk Purchase - Inventory',
        amount: 25000.0,
        isCredit: false,
        date: lastMonth.subtract(const Duration(days: 10)),
        category: 'Shopping',
        account: 'ICICI Bank',
        scope: TransactionScope.business,
      ),
      TransactionModel(
        id: '104',
        purpose: 'Dinner Party',
        amount: 8500.0,
        isCredit: false,
        date: lastMonth.subtract(const Duration(days: 2)),
        category: 'Food',
        account: 'Cash',
        scope: TransactionScope.personal,
      ),
    ]);
  }

  void applyFilters() {
    var results = allTransactions.where((tx) {
      final matchesSearch = tx.purpose.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          tx.category.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          tx.account.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      bool matchesType = true;
      if (selectedType.value == 'Income') matchesType = tx.isCredit;
      else if (selectedType.value == 'Expense') matchesType = !tx.isCredit;
      else if (selectedType.value == 'Cash') matchesType = tx.account.toLowerCase() == 'cash';
      else if (selectedType.value == 'Bank') matchesType = tx.account.toLowerCase() != 'cash';
      
      bool matchesCategory = selectedCategory.value == 'All' || tx.category == selectedCategory.value;
      bool matchesAccount = selectedAccount.value == 'All' || tx.account == selectedAccount.value;
      
      bool matchesScope = true;
      if (selectedScope.value == 'Business') matchesScope = tx.scope == TransactionScope.business;
      else if (selectedScope.value == 'Personal') matchesScope = tx.scope == TransactionScope.personal;
      
      bool matchesDate = true;
      if (startDate.value != null && endDate.value != null) {
        matchesDate = tx.date.isAfter(startDate.value!.subtract(const Duration(seconds: 1))) && 
                      tx.date.isBefore(endDate.value!.add(const Duration(days: 1)));
      }

      return matchesSearch && matchesType && matchesCategory && matchesAccount && matchesScope && matchesDate;
    }).toList();

    // Sort
    if (selectedSort.value == 'Latest first') {
      results.sort((a, b) => b.date.compareTo(a.date));
    } else if (selectedSort.value == 'Oldest first') {
      results.sort((a, b) => a.date.compareTo(b.date));
    } else if (selectedSort.value == 'Highest amount') {
      results.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (selectedSort.value == 'Lowest amount') {
      results.sort((a, b) => a.amount.compareTo(b.amount));
    }

    filteredTransactions.assignAll(results);
  }

  void clearAllFilters() {
    selectedType.value = 'All';
    selectedSort.value = 'Latest first';
    selectedCategory.value = 'All';
    selectedAccount.value = 'All';
    selectedScope.value = 'All';
    startDate.value = null;
    endDate.value = null;
    applyFilters();
  }

  void setSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void setType(String type) {
    selectedType.value = type;
    applyFilters();
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    applyFilters();
  }

  void deleteTransaction(String id) {
    allTransactions.removeWhere((tx) => tx.id == id);
    applyFilters();
  }

  Map<String, List<TransactionModel>> get groupedTransactions {
    final Map<String, List<TransactionModel>> groups = {};
    for (var tx in filteredTransactions) {
      final dateStr = _formatDateHeader(tx.date);
      if (!groups.containsKey(dateStr)) {
        groups[dateStr] = [];
      }
      groups[dateStr]!.add(tx);
    }
    return groups;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final txDate = DateTime(date.year, date.month, date.day);

    if (txDate == today) return 'Today, ${DateFormat('d MMMM yyyy').format(date)}';
    if (txDate == yesterday) return 'Yesterday, ${DateFormat('d MMMM yyyy').format(date)}';
    return DateFormat('d MMMM yyyy').format(date);
  }

  int get activeFilterCount {
    int count = 0;
    if (selectedType.value != 'All') count++;
    if (selectedSort.value != 'Latest first') count++;
    if (selectedCategory.value != 'All') count++;
    if (selectedAccount.value != 'All') count++;
    if (selectedScope.value != 'All') count++;
    if (startDate.value != null || endDate.value != null) count++;
    return count;
  }

  bool isTabActive(String tab) {
    switch (tab) {
      case 'Type': return tempType.value != 'All';
      case 'Sort': return tempSort.value != 'Latest first';
      case 'Category': return tempCategory.value != 'All';
      case 'Account': return tempAccount.value != 'All';
      case 'Business': return tempScope.value != 'All';
      case 'Date': return tempStart.value != null || tempEnd.value != null;
      default: return false;
    }
  }

  void clearTempFilters() {
    tempType.value = 'All';
    tempSort.value = 'Latest first';
    tempCategory.value = 'All';
    tempAccount.value = 'All';
    tempScope.value = 'All';
    tempStart.value = null;
    tempEnd.value = null;
  }

  int get uncategorizedCount => allTransactions.where((tx) => tx.isUncategorized).length;
}
