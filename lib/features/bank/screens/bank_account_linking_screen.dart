import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/styles.dart';

class BankAccountLinkingScreen extends StatefulWidget {
  const BankAccountLinkingScreen({super.key});

  @override
  State<BankAccountLinkingScreen> createState() => _BankAccountLinkingScreenState();
}

class _BankAccountLinkingScreenState extends State<BankAccountLinkingScreen> {
  final List<Map<String, dynamic>> _bankAccounts = [
    {
      'bankName': 'HDFC Bank',
      'last4': '4296',
      'type': 'Personal',
      'logo': Icons.account_balance,
      'color': const Color(0xFF1E3A6F),
    },
    {
      'bankName': 'ICICI Bank',
      'last4': '8821',
      'type': 'Business',
      'businessName': 'My Farm',
      'logo': Icons.account_balance,
      'color': const Color(0xFFF59E0B),
    },
    {
      'bankName': 'State Bank of India',
      'last4': '1044',
      'type': 'Personal',
      'logo': Icons.account_balance,
      'color': const Color(0xFF1976D2),
    },
  ];

  void _showAddBankSheet() {
    String selectedTag = 'Personal';
    String? selectedBusiness = 'My Farm';
    final List<String> businesses = ['My Farm', 'My Shop', 'Rentals'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Link Bank Account',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Account Tag', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTagChip('Personal', selectedTag == 'Personal', () => setModalState(() => selectedTag = 'Personal')),
                      const SizedBox(width: 12),
                      _buildTagChip('Business', selectedTag == 'Business', () => setModalState(() => selectedTag = 'Business')),
                    ],
                  ),
                  if (selectedTag == 'Business') ...[
                    const SizedBox(height: 20),
                    const Text('Select Business', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedBusiness,
                          isExpanded: true,
                          items: businesses.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setModalState(() => selectedBusiness = newValue);
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Mock add logic
                        Navigator.pop(context);
                        Get.snackbar('Success', 'Bank account linked successfully!', 
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.successColor,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A6F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('Add Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTagChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A6F) : Colors.grey[100],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? const Color(0xFF1E3A6F) : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Linked Accounts',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _bankAccounts.length,
        itemBuilder: (context, index) {
          final account = _bankAccounts[index];
          return _buildBankCard(account);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBankSheet,
        backgroundColor: const Color(0xFF1E3A6F),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Bank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBankCard(Map<String, dynamic> account) {
    final isBusiness = account['type'] == 'Business';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: account['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(account['logo'], color: account['color'], size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account['bankName'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                Text(
                  '**** **** **** ${account['last4']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isBusiness ? const Color(0xFFF59E0B).withOpacity(0.1) : const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  account['type'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isBusiness ? const Color(0xFFD97706) : const Color(0xFF4F46E5),
                  ),
                ),
              ),
              if (isBusiness) ...[
                const SizedBox(height: 4),
                Text(
                  account['businessName'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
