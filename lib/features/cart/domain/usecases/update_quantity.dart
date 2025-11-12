import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantity {
  final CartRepository repository;

  UpdateQuantity(this.repository);

  Future<bool> call(UpdateQuantityParams params) =>
      repository.updateQuantity(params.cartId, params.products);
}

class UpdateQuantityParams {
  final int cartId;
  final List<Map<String, dynamic>> products;

  UpdateQuantityParams({required this.cartId, required this.products});
}
