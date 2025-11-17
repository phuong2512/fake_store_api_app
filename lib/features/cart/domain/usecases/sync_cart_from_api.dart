import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class SyncCartFromApi {
  final CartRepository _repository;

  SyncCartFromApi(this._repository);

  Future<void> call(int userId) async {
    await _repository.syncCartFromApi(userId);
  }
}