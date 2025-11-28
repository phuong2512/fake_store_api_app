import 'package:fake_store_api_app/features/cart/data/models/cart_item_local_model.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_local_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class CartDao {
  @Query('SELECT * FROM carts WHERE userId = :userId')
  Future<List<CartLocalModel>> getCartsByUserId(int userId);

  @Query('SELECT * FROM carts WHERE id = :cartId')
  Future<CartLocalModel?> getCartById(int cartId);

  @insert
  Future<int> insertCart(CartLocalModel cart);

  @update
  Future<void> updateCart(CartLocalModel cart);

  @delete
  Future<void> deleteCart(CartLocalModel cart);

  @Query('SELECT * FROM cart_items WHERE cartId = :cartId')
  Future<List<CartItemLocalModel>> getCartItemsByCartId(int cartId);

  @Query('SELECT * FROM cart_items WHERE cartId IN (:cartIds)')
  Future<List<CartItemLocalModel>> getCartItemsByCartIds(List<int> cartIds);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCartItem(CartItemLocalModel cartItem);

  @update
  Future<void> updateCartItem(CartItemLocalModel cartItem);

  @delete
  Future<void> deleteCartItem(CartItemLocalModel cartItem);

  @Query('DELETE FROM cart_items WHERE cartId = :cartId')
  Future<void> deleteCartItemsByCartId(int cartId);

  @Query(
    'DELETE FROM cart_items WHERE cartId = :cartId AND productId = :productId',
  )
  Future<void> deleteCartItemByProductId(int cartId, int productId);

  @Query(
    'SELECT * FROM cart_items WHERE cartId = :cartId AND productId = :productId',
  )
  Future<CartItemLocalModel?> getCartItemByProductId(int cartId, int productId);

  @Query('DELETE FROM carts WHERE userId = :userId')
  Future<void> deleteCartsByUserId(int userId);
}
