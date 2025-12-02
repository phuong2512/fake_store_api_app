import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';

class GetCurrentCartId {
  final CartRepository _repository;

  GetCurrentCartId(this._repository);

  Future<int?> call(int userId) async {
    return await _repository.getCurrentCartId(userId);
  }
}
