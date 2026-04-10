import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/response_model.dart';

class ReportsRepository {
  final ApiClient _apiClient;

  ReportsRepository(this._apiClient);

  Future<ResponseModel> getBudgetStatus(int month, int year) async {
    return await _apiClient.get(
      '/api/v1/settings/budget-status',
      queryParameters: {
        'month': month,
        'year': year,
      },
      handleError: false,
    );
  }
}
