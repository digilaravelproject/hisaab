import '../../../../core/services/network/response_model.dart';
import '../repositories/profile_repository.dart';
import 'profile_service_interface.dart';

class ProfileService implements ProfileServiceInterface {
  final ProfileRepository _repository;

  ProfileService(this._repository);

  @override
  Future<ResponseModel> getProfile() async {
    return await _repository.getProfile();
  }
}
