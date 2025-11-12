import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<bool> call(AddToCartParams params) => repository.addToCart(
    params.cartId,
    params.productId,
    params.quantity,
    params.userId,
  );
}

class AddToCartParams {
  final int? cartId;
  final int productId;
  final int quantity;
  final int userId;

  AddToCartParams({
    this.cartId,
    required this.productId,
    required this.quantity,
    required this.userId,
  });
}
