import '../../../../core/services/network/response_model.dart';
import '../repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _repository;

  SettingsService(this._repository);

  Future<ResponseModel> fetchSettings() async {
    return await _repository.fetchSettings();
  }

  Future<ResponseModel> updateNotifications(bool enabled) async {
    return await _repository.updateNotifications(enabled);
  }

  Future<ResponseModel> updateBiometric(bool enabled) async {
    return await _repository.updateBiometric(enabled);
  }

  Future<ResponseModel> setPin(String pin) async {
    return await _repository.setPin(pin);
  }
}
