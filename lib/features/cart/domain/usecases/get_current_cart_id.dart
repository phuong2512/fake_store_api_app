import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class GetCurrentCartId {
  final CartRepository repository;

  GetCurrentCartId(this.repository);

  Future<int?> call(int userId) => repository.getCurrentCartId(userId);
}
