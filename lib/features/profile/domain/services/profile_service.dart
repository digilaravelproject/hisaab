import 'package:image_picker/image_picker.dart';
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

  @override
  Future<ResponseModel> updateProfile({
    required String name,
    required String email,
    required String gender,
    required String reminderTime,
    XFile? profilePhoto,
  }) async {
    return await _repository.updateProfile(
      name: name,
      email: email,
      gender: gender,
      reminderTime: reminderTime,
      profilePhoto: profilePhoto,
    );
  }
}
