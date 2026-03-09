import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/document_controller.dart';

class DocumentManagementScreen extends StatelessWidget {
  const DocumentManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DocumentController());

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Document Center', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: Obx(() {
          if (controller.currentPath.length > 1) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: controller.navigateBack,
            );
          }
          return IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.back(),
          );
        }),
      ),
      body: Column(
        children: [
          _buildBreadcrumbs(controller),
          Expanded(child: _buildItemsView(controller)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'document_management_fab',
        onPressed: controller.uploadFile,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add_a_photo, color: Colors.white),
      ),
    );
  }

  Widget _buildBreadcrumbs(DocumentController controller) {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() => ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.currentPath.length,
        separatorBuilder: (_, __) => const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        itemBuilder: (context, index) {
          final isLast = index == controller.currentPath.length - 1;
          return GestureDetector(
            onTap: () => controller.navigateToBreadcrumb(index),
            child: Center(
              child: Text(
                controller.currentPath[index],
                style: TextStyle(
                  color: isLast ? AppColors.primaryColor : Colors.grey[600],
                  fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  Widget _buildItemsView(DocumentController controller) {
    return Obx(() {
      final items = controller.currentItems;
      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open, size: 80, color: Colors.grey[200]),
              const SizedBox(height: 16),
              Text('This folder is empty', style: TextStyle(color: Colors.grey[400])),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(Dimensions.height15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(item, controller);
        },
      );
    });
  }

  Widget _buildItemCard(DocumentItem item, DocumentController controller) {
    final isFolder = item.type == DocType.folder;

    return GestureDetector(
      onTap: () => controller.navigateInto(item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'doc_${item.name}',
                  child: Icon(
                    isFolder ? Icons.folder : Icons.insert_drive_file,
                    size: 60,
                    color: isFolder ? Colors.amber[400] : Colors.blue[400],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            if (!isFolder) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.size ?? '', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                  GestureDetector(
                    onTap: () => controller.downloadItem(item),
                    child: Icon(Icons.download_rounded, size: 16, color: AppColors.primaryColor),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
