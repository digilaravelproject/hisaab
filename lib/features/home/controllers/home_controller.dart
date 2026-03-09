import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Business {
  String id;
  String name;

  Business({required this.id, required this.name});
}

class Customer {
  final String id;
  final String name;
  final String phone;
  final double balance; // Positive means "You will get" (Credit/Green), Negative means "You will give" (Debit/Red)
  final DateTime lastUpdated;
  final bool isSupplier;
  final DateTime? dueDate;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
    required this.lastUpdated,
    this.isSupplier = false,
    this.dueDate,
  });
}

class DeviceContact {
  final String name;
  final String phone;

  DeviceContact({required this.name, required this.phone});
}

class HomeController extends GetxController {
  final RxList<Customer> customers = <Customer>[].obs;
  
  final RxDouble totalYouWillGive = 0.0.obs;
  final RxDouble totalYouWillGet = 0.0.obs;
  final RxString searchQuery = ''.obs;
  final RxInt selectedTab = 0.obs; // 0 for Customer, 1 for Supplier
  final RxInt filterStatus = 0.obs; // 0: All, 1: Will Get, 2: Will Give, 3: Settled
  final RxInt filterDueDateStatus = 0.obs; // 0: All, 1: Due Today, 2: Upcoming, 3: No Due Date
  final RxInt sortBy = 0.obs; // 0: Recent, 1: Highest Amount, 2: Lowest Amount, 3: Name A-Z
  final RxInt filterMenuSelection = 0.obs; // 0: Sort By, 1: Balance Status, 2: Due Date
  
  final RxList<DeviceContact> deviceContacts = <DeviceContact>[].obs;
  final RxString contactSearchQuery = ''.obs;

  int get activeFilterCount {
    int count = 0;
    if (filterStatus.value != 0) count++;
    if (filterDueDateStatus.value != 0) count++;
    if (sortBy.value != 0) count++;
    return count;
  }
  
  final RxList<Business> businesses = <Business>[
    Business(id: '1', name: 'My Business'),
    Business(id: '2', name: 'Second Shop'),
  ].obs;
  
  late final Rx<Business> selectedBusiness;

  @override
  void onInit() {
    super.onInit();
    selectedBusiness = businesses.first.obs;
    _loadDummyData();
  }

  void setTab(int index) {
    selectedTab.value = index;
    _calculateTotals();
  }

  void _loadDummyData() {
    customers.value = [
      Customer(
        id: '1',
        name: 'Rahul Kumar',
        phone: '9876543210',
        balance: 5000.0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
        dueDate: DateTime.now(), // Due Today
      ),
      Customer(
        id: '2',
        name: 'Priya Singh',
        phone: '8765432109',
        balance: -2500.0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
        dueDate: DateTime.now().add(const Duration(days: 3)), // Upcoming
      ),
      Customer(
        id: '3',
        name: 'Amit Sharma',
        phone: '7654321098',
        balance: 1200.0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        // No Due Date
      ),
      Customer(
        id: '4',
        name: 'Neha Gupta',
        phone: '6543210987',
        balance: 0.0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Customer(
        id: '5',
        name: 'Super Wholesale',
        phone: '1234567890',
        balance: -15000.0,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
        isSupplier: true,
        dueDate: DateTime.now(), // Due Today
      ),
      Customer(
        id: '6',
        name: 'Ramesh Distributors',
        phone: '0987654321',
        balance: 500.0,
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
        isSupplier: true,
        dueDate: DateTime.now().add(const Duration(days: 5)), // Upcoming
      ),
    ];
    
    // Load Dummy Device Contacts
    deviceContacts.value = [
      DeviceContact(name: 'Aakash Verma', phone: '9898989898'),
      DeviceContact(name: 'Aditi Rao', phone: '8787878787'),
      DeviceContact(name: 'Bhavin Patel', phone: '7676767676'),
      DeviceContact(name: 'Chirag Desai', phone: '6565656565'),
      DeviceContact(name: 'Deepak Kumar', phone: '9988776655'),
      DeviceContact(name: 'Esha Gupta', phone: '9001002003'),
      DeviceContact(name: 'Firoz Ali', phone: '8005006007'),
      DeviceContact(name: 'Gaurav Sharma', phone: '7009001000'),
      DeviceContact(name: 'Jatin Reddy', phone: '9870123456'),
      DeviceContact(name: 'Kavita Das', phone: '9123456780'),
    ];
    
    _calculateTotals();
  }

  void _calculateTotals() {
    double give = 0.0;
    double get = 0.0;
    
    final activePersons = customers.where((c) => c.isSupplier == (selectedTab.value == 1)).toList();

    for (var person in activePersons) {
      if (person.balance > 0) {
        get += person.balance;
      } else if (person.balance < 0) {
        give += person.balance.abs();
      }
    }
    totalYouWillGive.value = give;
    totalYouWillGet.value = get;
  }

  List<Customer> get filteredCustomers {
    var list = customers.where((c) => c.isSupplier == (selectedTab.value == 1)).toList();
    if (searchQuery.value.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
    }
    
    // Balance Status filtering
    if (filterStatus.value == 1) { // Will Get (Credit) -> balance > 0
      list = list.where((c) => c.balance > 0).toList();
    } else if (filterStatus.value == 2) { // Will Give (Debit) -> balance < 0
      list = list.where((c) => c.balance < 0).toList();
    } else if (filterStatus.value == 3) { // Settled -> balance == 0
      list = list.where((c) => c.balance == 0).toList();
    }
    
    // Due Date filtering
    final today = DateTime.now();
    if (filterDueDateStatus.value == 1) { // Due Today
      list = list.where((c) => c.dueDate != null && 
        c.dueDate!.year == today.year && c.dueDate!.month == today.month && c.dueDate!.day == today.day).toList();
    } else if (filterDueDateStatus.value == 2) { // Upcoming
      list = list.where((c) => c.dueDate != null && 
        c.dueDate!.isAfter(DateTime(today.year, today.month, today.day, 23, 59, 59))).toList();
    } else if (filterDueDateStatus.value == 3) { // No Due Date
      list = list.where((c) => c.dueDate == null).toList();
    }

    // Sorting
    if (sortBy.value == 0) { // Recent
      list.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
    } else if (sortBy.value == 1) { // Highest Amount
      list.sort((a, b) => b.balance.abs().compareTo(a.balance.abs()));
    } else if (sortBy.value == 2) { // Lowest Amount
      list.sort((a, b) => a.balance.abs().compareTo(b.balance.abs()));
    } else if (sortBy.value == 3) { // Name A-Z
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    
    return list;
  }

  List<DeviceContact> get filteredDeviceContacts {
    var list = deviceContacts.toList();
    if (contactSearchQuery.value.isNotEmpty) {
      final query = contactSearchQuery.value.toLowerCase();
      list = list.where((c) => 
        c.name.toLowerCase().contains(query) || 
        c.phone.contains(query)
      ).toList();
    }
    // Sort alphabetically by default
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  void addBusiness(String name) {
    final newBusiness = Business(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    businesses.add(newBusiness);
    selectedBusiness.value = newBusiness;
  }

  void editBusiness(String id, String newName) {
    final index = businesses.indexWhere((b) => b.id == id);
    if (index != -1) {
      businesses[index].name = newName;
      businesses.refresh();
      if (selectedBusiness.value.id == id) {
        selectedBusiness.value = businesses[index];
      }
    }
  }

  void deleteBusiness(String id) {
    if (businesses.length > 1) {
      businesses.removeWhere((b) => b.id == id);
      if (selectedBusiness.value.id == id) {
        selectedBusiness.value = businesses.first;
      }
    } else {
      Get.snackbar('Cannot Delete', 'You must have at least one business.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
    }
  }

  void resetFilters() {
    filterStatus.value = 0;
    filterDueDateStatus.value = 0;
    sortBy.value = 0;
    filterMenuSelection.value = 0;
  }
}
