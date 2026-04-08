import '../../../../core/services/network/response_model.dart';

abstract class ProfileServiceInterface {
  Future<ResponseModel> getProfile();
}
