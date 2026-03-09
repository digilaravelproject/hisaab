import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DocType { folder, file }

class DocumentItem {
  final String name;
  final DocType type;
  final String? size;
  final String? date;
  final List<DocumentItem>? children;

  DocumentItem({
    required this.name,
    required this.type,
    this.size,
    this.date,
    this.children,
  });
}

class DocumentController extends GetxController {
  final currentPath = <String>['Documents'].obs;
  final currentItems = <DocumentItem>[].obs;
  
  // Entire mock hierarchy
  late List<DocumentItem> rootData;

  @override
  void onInit() {
    super.onInit();
    _initMockData();
    _updateCurrentItems();
  }

  void _initMockData() {
    rootData = [
      DocumentItem(
        name: 'My Farm',
        type: DocType.folder,
        children: [
          DocumentItem(
            name: '2024',
            type: DocType.folder,
            children: [
              DocumentItem(name: 'January', type: DocType.folder, children: [
                DocumentItem(name: 'Fertilizer_Bill_01.pdf', type: DocType.file, size: '1.2 MB', date: 'Jan 12, 2024'),
                DocumentItem(name: 'Diesel_Receipt.jpg', type: DocType.file, size: '850 KB', date: 'Jan 15, 2024'),
              ]),
              DocumentItem(name: 'February', type: DocType.folder, children: []),
            ],
          ),
          DocumentItem(name: '2025', type: DocType.folder, children: []),
        ],
      ),
      DocumentItem(
        name: 'My Shop',
        type: DocType.folder,
        children: [
          DocumentItem(name: '2024', type: DocType.folder, children: []),
          DocumentItem(name: '2025', type: DocType.folder, children: []),
        ],
      ),
      DocumentItem(name: 'Rentals', type: DocType.folder, children: []),
    ];
  }

  void _updateCurrentItems() {
    if (currentPath.length == 1) {
      currentItems.assignAll(rootData);
      return;
    }

    List<DocumentItem> temp = rootData;
    for (int i = 1; i < currentPath.length; i++) {
      final folderName = currentPath[i];
      final folder = temp.firstWhere((element) => element.name == folderName);
      temp = folder.children ?? [];
    }
    currentItems.assignAll(temp);
  }

  void navigateInto(DocumentItem item) {
    if (item.type == DocType.folder) {
      currentPath.add(item.name);
      _updateCurrentItems();
    } else {
      Get.snackbar('Preview', 'Opening ${item.name}...', 
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          colorText: Colors.blue);
    }
  }

  void navigateBack() {
    if (currentPath.length > 1) {
      currentPath.removeLast();
      _updateCurrentItems();
    }
  }

  void navigateToBreadcrumb(int index) {
    while (currentPath.length > index + 1) {
      currentPath.removeLast();
    }
    _updateCurrentItems();
  }

  void uploadFile() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upload to Current Folder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('You are uploading to: ${currentPath.join(' > ')}', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo / Scan'),
              onTap: () => _handleMockUpload(),
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Browse Files'),
              onTap: () => _handleMockUpload(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMockUpload() {
    Get.back();
    Get.snackbar('Success', 'File uploaded successfully!', 
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green);
  }

  void downloadItem(DocumentItem item) {
    Get.snackbar('Download', 'Downloading ${item.name}...',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green);
  }
}
