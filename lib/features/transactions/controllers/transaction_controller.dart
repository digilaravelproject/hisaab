import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../domain/models/dashboard_model.dart';
import '../domain/repositories/transaction_repository.dart';

enum TransactionType { income, expense, cash, bank }
enum TransactionScope { business, personal }

class TransactionModel {
  final String id;
  final String purpose;
  final double amount;
  final bool isCredit;
  final DateTime date;
  final String category;
  final int? categoryId;
  final String account; // Bank name or "Cash"
  final int? bankAccountId;
  final String? businessName;
  final int? businessId;
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
    this.categoryId,
    required this.account,
    this.bankAccountId,
    this.businessName,
    this.businessId,
    required this.scope,
    this.hasAttachment = false,
    this.note,
    this.isUncategorized = false,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    TransactionScope scope = TransactionScope.personal;
    int? bId;
    String? bName;
    
    final businessData = json['business'];
    if (businessData != null) {
      if (businessData is Map) {
        bId = businessData['id'] != null ? int.tryParse(businessData['id'].toString()) : null;
        bName = businessData['name']?.toString();
        // If name is 'Personal' or id is 0, 3 (standard Personal IDs), it's Personal
        if (bName != null && bName.toLowerCase() != 'personal' && bId != null && bId != 0 && bId != 3) {
          scope = TransactionScope.business;
        }
      } else {
        bId = int.tryParse(businessData.toString());
        if (bId != 0 && bId != null && bId != 3) {
          scope = TransactionScope.business;
        }
      }
    }

    final categoryData = json['category'];
    int? catId;
    String catName = 'Uncategorized';
    if (categoryData != null && categoryData is Map) {
      catId = categoryData['id'] != null ? int.tryParse(categoryData['id'].toString()) : null;
      catName = categoryData['name'] ?? 'Uncategorized';
    }

    final bankData = json['bank_account'];
    int? bankId;
    if (bankData != null && bankData is Map) {
      bankId = bankData['id'] != null ? int.tryParse(bankData['id'].toString()) : null;
    }

    return TransactionModel(
      id: json['id']?.toString() ?? '',
      purpose: json['description'] ?? '',
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      isCredit: json['type'] == 'credit',
      date: json['transaction_date'] != null ? DateTime.parse(json['transaction_date']) : DateTime.now(),
      category: catName,
      categoryId: catId,
      account: (json['source']?.toString() ?? 'Cash').capitalizeFirst ?? 'Cash',
      bankAccountId: bankId,
      businessId: bId,
      businessName: bName,
      scope: scope,
      note: json['description'],
      isUncategorized: json['is_categorized'] == false,
    );
  }
}

class TransactionController extends GetxController {
  final TransactionRepository _repository;
  TransactionController({required TransactionRepository repository}) : _repository = repository;

  final allTransactions = <TransactionModel>[].obs;
  final filteredTransactions = <TransactionModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  
  final searchQuery = ''.obs;
  final selectedType = 'All'.obs; 
  final selectedSort = 'Latest first'.obs;
  final selectedCategory = 'All'.obs;
  final selectedAccount = 'All'.obs;
  final selectedScope = 'All'.obs; // All, Business, Personal
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);

  // Pagination state
  int _currentPage = 1;
  int _lastPage = 1;
  final isMoreDataAvailable = true.obs;
  final isPaginationLoading = false.obs;

  // ... (rest of the controller remains same)
  
  Future<bool> addTransaction(Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      final response = await _repository.createTransaction(data);
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(response.message);
        loadTransactions(isRefresh: true);
        return true;
      } else {
        CustomSnackbar.showError(response.message);
      }
    } catch (e) {
      CustomSnackbar.showError('Operation failed: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  Future<bool> updateTransaction(String id, Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      final response = await _repository.updateTransaction(id, data);
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(response.message);
        loadTransactions(isRefresh: true);
        return true;
      } else {
        CustomSnackbar.showError(response.message);
      }
    } catch (e) {
      CustomSnackbar.showError('Update failed: $e');
    } finally {
      isSaving.value = false;
    }
    return false;
  }

  final selectedCategoryId = Rx<int?>(null);
  final selectedBusinessId = Rx<int?>(null);
  final selectedBankAccountId = Rx<int?>(null);

  final personalDashboard = Rxn<DashboardModel>();
  final businessDashboard = Rxn<DashboardModel>();
  final isDashboardLoading = false.obs;
  
  final categories = <String>[].obs;
  final accounts = <String>[].obs;
  final isSearchLoading = false.obs;

  // Temporary states for the Filter Bottom Sheet session
  final tempType = 'All'.obs;
  final tempSort = 'Latest first'.obs;
  final tempCategory = 'All'.obs;
  final tempCategoryId = Rx<int?>(null);
  final tempBusinessId = Rx<int?>(null);
  final tempBankAccountId = Rx<int?>(null);
  final tempAccount = 'All'.obs;
  final tempScope = 'All'.obs;
  final tempStart = Rx<DateTime?>(null);
  final tempEnd = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
    
    // Debounce search API calls - now calls unified loadTransactions
    debounce(searchQuery, (_) {
      loadTransactions(isRefresh: true);
    }, time: const Duration(milliseconds: 500));
  }

  Future<void> loadTransactions({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      isMoreDataAvailable.value = true;
    }

    if (!isMoreDataAvailable.value || (isPaginationLoading.value && !isRefresh)) return;

    try {
      if (isRefresh) {
        isLoading.value = true;
      } else {
        isPaginationLoading.value = true;
      }

      final Map<String, dynamic> params = {
        'page': _currentPage.toString(),
        'per_page': '20',
      };
      
      // Search
      if (searchQuery.value.isNotEmpty) {
        params['search_string'] = searchQuery.value;
      }

      // Category Filter
      if (selectedCategoryId.value != null) {
        params['category_id'] = selectedCategoryId.value.toString();
      }

      // Type Filter
      if (selectedType.value != 'All') {
        if (selectedType.value == 'Income') params['type'] = 'credit';
        else if (selectedType.value == 'Expense') params['type'] = 'debit';
      }

      // Account/Source Filter
      if (selectedAccount.value != 'All') {
        params['source'] = selectedAccount.value.toLowerCase();
      }
      
      // Business Filter
      if (selectedBusinessId.value != null) {
        params['business_id'] = selectedBusinessId.value.toString();
      }
      
      // Bank Account Filter
      if (selectedBankAccountId.value != null) {
        params['bank_account_id'] = selectedBankAccountId.value.toString();
      }

      // Date Range
      if (startDate.value != null) {
        params['from_date'] = DateFormat('yyyy-MM-dd').format(startDate.value!);
      }
      if (endDate.value != null) {
        params['to_date'] = DateFormat('yyyy-MM-dd').format(endDate.value!);
      }

      final response = await _repository.getTransactions(params);
      
      if (response.isSuccess && response.body is List) {
        final List<dynamic> list = response.body;
        final newTransactions = list.map((json) => TransactionModel.fromJson(json)).toList();

        if (isRefresh) {
          allTransactions.assignAll(newTransactions);
        } else {
          allTransactions.addAll(newTransactions);
        }

        // Handle meta for pagination
        if (response.meta != null) {
          _currentPage = response.meta!['current_page'] ?? _currentPage;
          _lastPage = response.meta!['last_page'] ?? _lastPage;
          isMoreDataAvailable.value = _currentPage < _lastPage;
          if (isMoreDataAvailable.value) {
            _currentPage++;
          }
        } else {
          isMoreDataAvailable.value = false;
        }
        
        // Always maintain filter options for existing local categorizers if needed
        if (selectedCategoryId.value == null) {
          _extractFilterOptions();
        }
        applyFilters();
      }
    } catch (e) {
      // Silently handle
    } finally {
      isLoading.value = false;
      isPaginationLoading.value = false;
    }
  }



  void initTempFilters() {
    tempType.value = selectedType.value;
    tempSort.value = selectedSort.value;
    tempCategory.value = selectedCategory.value;
    tempCategoryId.value = selectedCategoryId.value;
    tempBusinessId.value = selectedBusinessId.value;
    tempBankAccountId.value = selectedBankAccountId.value;
    tempAccount.value = selectedAccount.value;
    tempScope.value = selectedScope.value;
    tempStart.value = startDate.value;
    tempEnd.value = endDate.value;
  }

  // Financial Summary Methods for Home Screen
  double getTotalIncome(TransactionScope scope) {
    return allTransactions
        .where((tx) => tx.scope == scope && tx.isCredit)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double getTotalExpense(TransactionScope scope) {
    return allTransactions
        .where((tx) => tx.scope == scope && !tx.isCredit)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double getNetBalance(TransactionScope scope) {
    return getTotalIncome(scope) - getTotalExpense(scope);
  }

  // Today activity
  double getTodayCredit(TransactionScope scope) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return allTransactions
        .where((tx) => 
            tx.scope == scope && 
            tx.isCredit && 
            tx.date.year == today.year && 
            tx.date.month == today.month && 
            tx.date.day == today.day)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  double getTodayDebit(TransactionScope scope) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return allTransactions
        .where((tx) => 
            tx.scope == scope && 
            !tx.isCredit && 
            tx.date.year == today.year && 
            tx.date.month == today.month && 
            tx.date.day == today.day)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  void commitFilters() {
    selectedType.value = tempType.value;
    selectedSort.value = tempSort.value;
    selectedCategory.value = tempCategory.value;
    selectedCategoryId.value = tempCategoryId.value;
    selectedBusinessId.value = tempBusinessId.value;
    selectedBankAccountId.value = tempBankAccountId.value;
    selectedAccount.value = tempAccount.value;
    selectedScope.value = tempScope.value;
    startDate.value = tempStart.value;
    endDate.value = tempEnd.value;
    loadTransactions(isRefresh: true);
  }

  void _extractFilterOptions() {
    final cats = allTransactions.map((tx) => tx.category).toSet().toList();
    cats.sort();
    categories.assignAll(['All', ...cats]);

    final accs = allTransactions.map((tx) => tx.account).toSet().toList();
    accs.sort();
    accounts.assignAll(['All', ...accs]);
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
    selectedCategoryId.value = null;
    selectedAccount.value = 'All';
    selectedScope.value = 'All';
    startDate.value = null;
    endDate.value = null;
    loadTransactions(isRefresh: true);
  }

  void setSearch(String query) {
    searchQuery.value = query;
  }

  void setType(String type) {
    selectedType.value = type;
    loadTransactions(isRefresh: true);
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    applyFilters();
  }

  Future<bool> deleteTransaction(String id) async {
    try {
      final response = await _repository.deleteTransaction(id);
      if (response.isSuccess) {
        allTransactions.removeWhere((tx) => tx.id == id);
        applyFilters();
        CustomSnackbar.showSuccess(response.message);
        return true;
      } else {
        CustomSnackbar.showError(response.message);
        return false;
      }
    } catch (e) {
      CustomSnackbar.showError('Failed to delete transaction: $e');
      return false;
    }
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
      case 'Scope': return tempScope.value != 'All';
      case 'Date': return tempStart.value != null || tempEnd.value != null;
      default: return false;
    }
  }

  void clearTempFilters() {
    tempType.value = 'All';
    tempSort.value = 'Latest first';
    tempCategory.value = 'All';
    tempCategoryId.value = null;
    tempBusinessId.value = null;
    tempBankAccountId.value = null;
    tempAccount.value = 'All';
    tempScope.value = 'All';
    tempStart.value = null;
    tempEnd.value = null;
  }

  int get uncategorizedCount => allTransactions.where((tx) => tx.isUncategorized).length;

  bool hasDataInScope(TransactionScope scope) {
    return allTransactions.any((tx) => tx.scope == scope);
  }

  Future<void> pickAndUploadReceipt(String transactionId, {ImageSource? source, bool isPdf = false}) async {
    try {
      if (isPdf) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
        if (result != null) {
          await _uploadReceipt(transactionId, document: result);
        }
      } else if (source != null) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          await _uploadReceipt(transactionId, image: image);
        }
      }
    } catch (e) {
      CustomSnackbar.showError('Failed to pick file: $e');
    }
  }

  Future<void> _uploadReceipt(String transactionId, {XFile? image, FilePickerResult? document}) async {
    try {
      isLoading.value = true;
      final response = await _repository.uploadReceipt(transactionId, image: image, document: document);
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(response.message);
        loadTransactions(isRefresh: true);
      } else {
        CustomSnackbar.showError(response.message);
      }
    } catch (e) {
      CustomSnackbar.showError('Upload failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> categorizeTransaction(String id, int categoryId, {int? businessId}) async {
    try {
      isLoading.value = true;
      final response = await _repository.categorizeTransaction(id, {
        "category_id": categoryId,
        "business_id": businessId,
      });
      if (response.isSuccess) {
        CustomSnackbar.showSuccess(response.message);
        loadTransactions(isRefresh: true);
      } else {
        CustomSnackbar.showError(response.message);
      }
    } catch (e) {
      CustomSnackbar.showError('Categorization failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDashboardData({bool isBusiness = false}) async {
    try {
      isDashboardLoading.value = true;
      final response = await _repository.getDashboardData(isBusiness: isBusiness);
      if (response.isSuccess) {
        final dashboard = DashboardModel.fromJson(response.body);
        if (isBusiness) {
          businessDashboard.value = dashboard;
        } else {
          personalDashboard.value = dashboard;
        }
      }
    } catch (e) {
      CustomSnackbar.showError('Failed to load dashboard: $e');
    } finally {
      isDashboardLoading.value = false;
    }
  }
}
