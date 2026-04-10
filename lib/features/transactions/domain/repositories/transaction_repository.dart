import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/response_model.dart';

class TransactionRepository {
  final ApiClient _apiClient;

  TransactionRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ResponseModel> createTransaction(Map<String, dynamic> data) async {
    return await _apiClient.post(
      '/api/v1/transactions',
      data: data,
      handleError: false,
    );
  }

  Future<ResponseModel> getTransactions(Map<String, dynamic> queryParameters) async {
    return await _apiClient.get(
      '/api/v1/transactions',
      queryParameters: queryParameters,
      showToaster: false,
      handleError: false,
    );
  }

  Future<ResponseModel> searchTransactions(String query) async {
    return await _apiClient.get(
      '/api/v1/transactions/search',
      queryParameters: {'q': query},
      showToaster: false,
      handleError: false,
    );
  }

  Future<ResponseModel> deleteTransaction(String id) async {
    return await _apiClient.delete(
      '/api/v1/transactions/$id',
    );
  }
}
