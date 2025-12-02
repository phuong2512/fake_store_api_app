import 'package:fake_store_api_app/core/models/cart.dart';
import 'package:floor/floor.dart';

@dao
abstract class CartDao {
  @Query('SELECT * FROM carts WHERE userId = :userId')
  Future<List<CartModel>> getCartsByUserId(int userId);

  @Query('SELECT * FROM carts WHERE id = :cartId')
  Future<CartModel?> getCartById(int cartId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertCart(CartModel cart);

  @update
  Future<void> updateCart(CartModel cart);

  @delete
  Future<void> deleteCart(CartModel cart);

  @Query('DELETE FROM carts WHERE userId = :userId')
  Future<void> deleteCartsByUserId(int userId);
}
