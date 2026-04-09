import '../../../../core/services/network/response_model.dart';
import '../services/help_support_service.dart';

class ContactUsUseCase {
  final HelpSupportService _supportService;
  String? lastErrorMessage;

  ContactUsUseCase(this._supportService);

  Future<bool> execute({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final response = await _supportService.submitContactUs({
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    });

    if (response.isSuccess) {
      return true;
    }
    lastErrorMessage = response.message;
    return false;
  }
}
