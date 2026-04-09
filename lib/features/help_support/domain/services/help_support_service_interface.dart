import '../../../../core/services/network/response_model.dart';

abstract class HelpSupportServiceInterface {
  Future<ResponseModel> getStaticPage(String path);
  Future<ResponseModel> submitContactUs(Map<String, dynamic> data);
}
