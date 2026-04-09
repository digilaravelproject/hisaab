import 'package:image_picker/image_picker.dart';
import '../../../../core/services/network/response_model.dart';

abstract class ProfileRepositoryInterface {
  Future<ResponseModel> getProfile();
  Future<ResponseModel> updateProfile({
    required String name,
    required String email,
    required String gender,
    required String reminderTime,
    XFile? profilePhoto,
  });
}
