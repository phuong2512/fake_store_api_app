import 'package:fake_store_api_app/features/cart/data/models/cart_entity.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_item_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class CartDao {
  @Query('SELECT * FROM carts WHERE userId = :userId')
  Future<List<CartEntity>> getCartsByUserId(int userId);

  @Query('SELECT * FROM carts WHERE id = :cartId')
  Future<CartEntity?> getCartById(int cartId);

  @insert
  Future<void> insertCart(CartEntity cart);

  @update
  Future<void> updateCart(CartEntity cart);

  @delete
  Future<void> deleteCart(CartEntity cart);

  @Query('SELECT * FROM cart_items WHERE cartId = :cartId')
  Future<List<CartItemEntity>> getCartItemsByCartId(int cartId);

  @Query('SELECT * FROM cart_items WHERE cartId IN (:cartIds)')
  Future<List<CartItemEntity>> getCartItemsByCartIds(List<int> cartIds);

  @insert
  Future<void> insertCartItem(CartItemEntity cartItem);

  @update
  Future<void> updateCartItem(CartItemEntity cartItem);

  @delete
  Future<void> deleteCartItem(CartItemEntity cartItem);

  @Query('DELETE FROM cart_items WHERE cartId = :cartId')
  Future<void> deleteCartItemsByCartId(int cartId);

  @Query(
    'DELETE FROM cart_items WHERE cartId = :cartId AND productId = :productId',
  )
  Future<void> deleteCartItemByProductId(int cartId, int productId);

  @Query(
    'SELECT * FROM cart_items WHERE cartId = :cartId AND productId = :productId',
  )
  Future<CartItemEntity?> getCartItemByProductId(int cartId, int productId);

  @Query('DELETE FROM carts WHERE userId = :userId')
  Future<void> deleteCartsByUserId(int userId);
}
