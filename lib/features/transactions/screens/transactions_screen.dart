import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_theme.dart';
import '../../../routes/route_helper.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../../../core/utils/transaction_helper.dart';
import '../../../core/utils/transaction_action_sheet.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/transaction_controller.dart';
import '../controllers/category_controller.dart';
import '../domain/models/category_model.dart';
import '../../settings/controllers/settings_controller.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TransactionController controller = Get.find();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      controller.setSearch(_searchController.text);
    });
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        controller.loadTransactions(isRefresh: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transactions', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.slate800),
        ),
        centerTitle: false,
        titleSpacing: 20,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.slate800,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Obx(() {
            int count = controller.activeFilterCount;
            return Badge(
              label: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              isLabelVisible: count > 0,
              backgroundColor: AppColors.primaryColor,
              offset: const Offset(-2, 2),
              child: IconButton(
                icon: const Icon(Icons.filter_list_rounded, size: 22, color: AppColors.slate500),
                onPressed: () => _showAdvancedFilters(context),
              ),
            );
          }),
          const SizedBox(width: 12),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.loadTransactions(isRefresh: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildUncategorizedBanner(),
              _buildStickySearchBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  final groups = controller.groupedTransactions;
                  if (groups.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: _buildEmptyState(),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 200),
                    itemCount: groups.length + (controller.isPaginationLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == groups.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      }
                      final date = groups.keys.elementAt(index);
                      final txs = groups[date]!;
                      return _buildGroupedSection(date, txs);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'transactions_filter_fab',
        onPressed: () => _showAdvancedFilters(context),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.tune_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildUncategorizedBanner() {
    return Obx(() {
      final count = controller.uncategorizedCount;
      if (count == 0) return const SizedBox.shrink();
      return InkWell(
        onTap: () => Get.find<SettingsController>().showPlaceholderAction('Category Manager'),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$count transactions need category selection',
                  style: TextStyle(
                    color: Colors.amber.shade900,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.amber, size: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStickySearchBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.slate100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
  ]
    );
  }

  Widget _buildGroupedSection(String dateStr, List<TransactionModel> txs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: InkWell(
            onTap: () => _showAdvancedFilters(context),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: txs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildTransactionCard(txs[index]),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(TransactionModel tx) {
    return Dismissible(
      key: Key(tx.id),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final confirmed = await TransactionActionSheet.confirmDelete(context);
          if (confirmed == true) {
            return await controller.deleteTransaction(tx.id);
          }
          return false;
        } else {
          return false;
        }
      },
      onDismissed: (_) {
         // Data already removed from controller in confirmDismiss if successful
      },
      background: _buildSwipeAction(Icons.edit_outlined, Colors.blue, Alignment.centerLeft),
      secondaryBackground: _buildSwipeAction(Icons.delete_outline_rounded, Colors.red, Alignment.centerRight),
      child: InkWell(
        onTap: () => TransactionActionSheet.show(context, tx),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              // Icon
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
              
              // Middle Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tx.purpose,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.slate800, fontSize: 14),
                          ),
                        ),
                        // if (tx.scope == TransactionScope.business)
                        //   Container(
                        //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //     decoration: BoxDecoration(
                        //       color: AppColors.slate200,
                        //       borderRadius: BorderRadius.circular(4),
                        //     ),
                        //     child: const Text('Business', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.slate600)),
                        //   ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(tx.account, style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('•', style: TextStyle(color: Colors.grey))),
                        Text(DateFormat('dd MMM, hh:mm a').format(tx.date), style: const TextStyle(fontSize: 12, color: AppColors.slate500)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Right side
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${tx.isCredit ? "+" : "-"} ₹${tx.amount.toInt()}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: tx.isCredit ? AppColors.emerald500 : AppColors.rose500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tx.isUncategorized)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(4)),
                          child: Text('Select Category', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.amber.shade900)),
                        ),
                      if (tx.hasAttachment)
                        const Icon(Icons.attach_file_rounded, size: 14, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeAction(IconData icon, Color color, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Add your first entry'),
          ),
        ],
      ),
    );
  }

  // Helper methods replaced by TransactionHelper

  // _confirmDelete replaced by TransactionActionSheet

  void _showAdvancedFilters(BuildContext context) {
    final activeTab = 'Sort'.obs; // Sort, Type, Category, Account, Date
    controller.initTempFilters();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.slate100),
            
            // Body
            Expanded(
              child: Row(
                children: [
                  // Left Side - Menu
                  Container(
                    width: 120,
                    color: Colors.grey.shade50,
                    child: Column(
                      children: [
                        _buildFilterMenuTab('Sort', activeTab),
                        _buildFilterMenuTab('Type', activeTab),
                        _buildFilterMenuTab('Category', activeTab),
                        _buildFilterMenuTab('Account', activeTab),
                        _buildFilterMenuTab('Business', activeTab),
                        _buildFilterMenuTab('Date', activeTab),
                      ],
                    ),
                  ),
                  
                  // Right Side - Content
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Obx(() {
                        switch (activeTab.value) {
                          case 'Sort': return _buildSortOptions();
                          case 'Type': return _buildTypeOptions();
                          case 'Category': return _buildCategoryOptions();
                          case 'Account': return _buildAccountOptions();
                          case 'Business': return _buildBusinessOptions();
                          case 'Date': return _buildDateOptions(context);
                          default: return const SizedBox.shrink();
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
            
            Container(height: 1, color: AppColors.slate100),
            
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.clearAllFilters();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Clear All', style: TextStyle(color: AppColors.primaryColor)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.commitFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterMenuTab(String label, RxString activeTab) {
    return Obx(() {
      bool isSelected = activeTab.value == label;
      bool isTabActive = controller.isTabActive(label);
      
      return InkWell(
        onTap: () => activeTab.value = label,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            border: isSelected ? Border(left: BorderSide(color: AppColors.primaryColor, width: 4)) : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primaryColor : Colors.black54,
                  ),
                ),
              ),
              if (isTabActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSortOptions() {
    final options = ['Latest first', 'Oldest first', 'Highest amount', 'Lowest amount'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: options.map((opt) => _buildSelectionItem(opt, controller.tempSort)).toList(),
    );
  }

  Widget _buildTypeOptions() {
    final options = ['Credit', 'Debit'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: options.map((opt) => _buildSelectionItem(opt, controller.tempType)).toList(),
    );
  }

  Widget _buildCategoryOptions() {
    final catController = Get.find<CategoryController>();
    return Obx(() {
      final allCats = [
        CategoryModel(id: 0, name: 'All', type: '', icon: '', isCustom: false),
        ...catController.categories,
      ];
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allCats.length,
        itemBuilder: (context, index) {
          final cat = allCats[index];
          return Obx(() {
            final isSelected = controller.tempCategory.value == cat.name;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor.withOpacity(0.08) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor.withOpacity(0.2) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: ListTile(
                onTap: () {
                  controller.tempCategory.value = cat.name;
                  controller.tempCategoryId.value = cat.id == 0 ? null : cat.id;
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor.withOpacity(0.15) : Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: cat.id == 0 
                      ? Icon(Icons.apps_rounded, color: isSelected ? AppColors.primaryColor : Colors.grey.shade400, size: 20)
                      : Icon(TransactionHelper.getCategoryIcon(cat.name), color: isSelected ? AppColors.primaryColor : Colors.grey.shade400, size: 20),
                ),
                title: Text(
                  cat.name, 
                  style: TextStyle(
                    fontSize: 15, 
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primaryColor : AppColors.slate800,
                  ),
                ),
                trailing: Radio<String>(
                  value: cat.name,
                  groupValue: controller.tempCategory.value,
                  onChanged: (val) {
                    controller.tempCategory.value = cat.name;
                    controller.tempCategoryId.value = cat.id == 0 ? null : cat.id;
                  },
                  activeColor: AppColors.primaryColor,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildAccountOptions() {
    final options = ['All', 'Cash', 'Bank', 'UPI'];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final opt = options[index];
        return _buildSelectionItem(opt, controller.tempAccount);
      },
    );
  }

  Widget _buildDateOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final start = controller.tempStart.value;
        final end = controller.tempEnd.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('From', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: start ?? DateTime.now().subtract(const Duration(days: 30)),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.light(primary: AppColors.primaryColor, onPrimary: Colors.white),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) controller.tempStart.value = picked;
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: start != null ? AppColors.primaryColor : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 18, color: start != null ? AppColors.primaryColor : Colors.grey.shade400),
                    const SizedBox(width: 12),
                    Text(
                      start != null ? DateFormat('dd MMM, yyyy').format(start) : 'Select from date',
                      style: TextStyle(color: start != null ? AppColors.slate800 : Colors.grey.shade400, fontWeight: start != null ? FontWeight.bold : FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('To', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: end ?? DateTime.now(),
                  firstDate: start ?? DateTime(2020),
                  lastDate: DateTime(2030),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.light(primary: AppColors.primaryColor, onPrimary: Colors.white),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) controller.tempEnd.value = picked;
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: end != null ? AppColors.primaryColor : Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 18, color: end != null ? AppColors.primaryColor : Colors.grey.shade400),
                    const SizedBox(width: 12),
                    Text(
                      end != null ? DateFormat('dd MMM, yyyy').format(end) : 'Select to date',
                      style: TextStyle(color: end != null ? AppColors.slate800 : Colors.grey.shade400, fontWeight: end != null ? FontWeight.bold : FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBusinessOptions() {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final busList = homeController?.businesses ?? [];
    
    final allOptions = [
       {'id': null, 'name': 'All'},
       ...busList.map((b) => {'id': int.tryParse(b.id), 'name': b.name}),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allOptions.length,
      itemBuilder: (context, index) {
        final opt = allOptions[index];
        final name = opt['name'] as String;
        final id = opt['id'] as int?;
        
        return Obx(() {
          final isSelected = controller.tempBusinessId.value == id && (id != null || controller.tempScope.value == 'All');
          // For 'All', we also check tempScope just in case
          final effectiveSelected = id == null ? (controller.tempBusinessId.value == null) : (controller.tempBusinessId.value == id);

          return Container(
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: effectiveSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                controller.tempBusinessId.value = id;
                if (id == null) {
                  controller.tempScope.value = 'All';
                } else {
                  controller.tempScope.value = name;
                }
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                name, 
                style: TextStyle(
                  fontSize: 14, 
                  color: effectiveSelected ? AppColors.primaryColor : AppColors.slate800,
                  fontWeight: effectiveSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: effectiveSelected 
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor, size: 20)
                  : null,
            ),
          );
        });
      },
    );
  }

  // _showTransactionActions and related UI items moved to TransactionActionSheet

  Widget _buildSelectionItem(String label, RxString observable) {
    return Obx(() {
      final isSelected = observable.value == label;
      return Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () => observable.value = label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            label, 
            style: TextStyle(
              fontSize: 14, 
              color: isSelected ? AppColors.primaryColor : AppColors.slate800,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected 
              ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryColor, size: 20)
              : null,
        ),
      );
    });
  }
}
