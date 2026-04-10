import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/response_model.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ResponseModel> getCategories() async {
    final response = await _apiClient.get(
      '/api/v1/categories',
      handleError: false,
      showToaster: false,
    );
    if (response.isSuccess && response.body != null) {
      final List<CategoryModel> categories = (response.body as List)
          .map((data) => CategoryModel.fromJson(data))
          .toList();
      return response.copyWith(body: categories);
    }
    return response;
  }
}
