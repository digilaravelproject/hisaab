import 'package:get/get.dart';
import '../domain/models/category_model.dart';
import '../domain/repositories/category_repository.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repository;

  CategoryController({required CategoryRepository repository}) : _repository = repository;

  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await _repository.getCategories();
      if (response.isSuccess) {
        categories.assignAll(response.body as List<CategoryModel>);
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<CategoryModel> getCategoriesByType(String type) {
    // type should be 'income' or 'expense'
    return categories.where((c) => c.type.toLowerCase() == type.toLowerCase()).toList();
  }
}
