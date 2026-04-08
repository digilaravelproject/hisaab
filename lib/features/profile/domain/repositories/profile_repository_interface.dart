import '../../../../core/services/network/response_model.dart';

abstract class ProfileRepositoryInterface {
  Future<ResponseModel> getProfile();
}
