import '../models/static_page_model.dart';
import '../services/help_support_service.dart';

class GetStaticPageUseCase {
  final HelpSupportService _supportService;
  String? lastErrorMessage;

  GetStaticPageUseCase(this._supportService);

  Future<StaticPageModel?> execute(String path) async {
    final response = await _supportService.getStaticPage(path);
    if (response.isSuccess && response.body != null) {
      try {
        final body = response.body as Map<String, dynamic>;
        final data = body['data'] ?? body;
        final pageData = data['page'] ?? data;
        return StaticPageModel.fromJson(pageData as Map<String, dynamic>);
      } catch (e) {
        lastErrorMessage = 'Failed to parse page data: $e';
        return null;
      }
    }
    lastErrorMessage = response.message;
    return null;
  }
}
