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

  Future<ResponseModel> updateReminderTime(String time) async {
    return await _repository.updateReminderTime(time);
  }

  Future<ResponseModel> updateWeeklyBudget(double amount) async {
    return await _repository.updateWeeklyBudget(amount);
  }

  Future<ResponseModel> updateMonthlyBudget(double amount) async {
    return await _repository.updateMonthlyBudget(amount);
  }

  Future<ResponseModel> updateBiometric(bool enabled) async {
    return await _repository.updateBiometric(enabled);
  }

  Future<ResponseModel> setPin(String pin) async {
    return await _repository.setPin(pin);
  }

  Future<ResponseModel> clearCache() async {
    return await _repository.clearCache();
  }
}
