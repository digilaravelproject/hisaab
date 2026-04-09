import '../../../../core/services/network/response_model.dart';
import '../repositories/help_support_repository.dart';
import 'help_support_service_interface.dart';

class HelpSupportService implements HelpSupportServiceInterface {
  final HelpSupportRepository _repository;

  HelpSupportService(this._repository);

  @override
  Future<ResponseModel> getStaticPage(String path) async {
    return await _repository.getStaticPage(path);
  }

  @override
  Future<ResponseModel> submitContactUs(Map<String, dynamic> data) async {
    return await _repository.submitContactUs(data);
  }
}
