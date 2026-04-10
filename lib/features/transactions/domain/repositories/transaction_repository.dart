import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/network/multipart.dart';
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

  Future<ResponseModel> deleteTransaction(String id) async {
    return await _apiClient.delete(
      '/api/v1/transactions/$id',
    );
  }

  Future<ResponseModel> updateTransaction(String id, Map<String, dynamic> data) async {
    return await _apiClient.put(
      '/api/v1/transactions/$id',
      data: data,
      handleError: false,
    );
  }

  Future<ResponseModel> uploadReceipt(String id, {XFile? image, FilePickerResult? document}) async {
    return await _apiClient.postMultipartData(
      '/api/v1/transactions/$id/receipt',
      {}, // no additional body fields
      image != null ? [MultipartBody('receipt', image)] : [],
      document != null ? [MultipartDocument('receipt', document)] : [],
      handleError: false,
    );
  }

  Future<ResponseModel> categorizeTransaction(String id, Map<String, dynamic> data) async {
    return await _apiClient.patch(
      '/api/v1/transactions/$id/categorize',
      data: data,
      handleError: false,
    );
  }

  Future<ResponseModel> getDashboardData({bool isBusiness = false}) async {
    final path = isBusiness ? '/api/v1/transactions/dashboard/business' : '/api/v1/transactions/dashboard';
    return await _apiClient.get(
      path,
      showToaster: false,
      handleError: false,
    );
  }
}
