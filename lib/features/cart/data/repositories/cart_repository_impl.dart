import 'package:fake_store_api_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_item_entity.dart';
import 'package:fake_store_api_app/features/cart/domain/entities/cart_item.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<CartItem>> getUserCart(int userId) async {
    final carts = await _localDataSource.getCartsByUserId(userId);

    if (carts.isEmpty) {
      return [];
    }

    final cartIds = carts.map((c) => c.id).toList();
    final cartItems = await _localDataSource.getCartItemsByCartIds(cartIds);

    // Consolidate items
    final Map<int, int> consolidated = {};
    for (var item in cartItems) {
      consolidated[item.productId] =
          (consolidated[item.productId] ?? 0) + item.quantity;
    }

    return consolidated.entries
        .map((e) => CartItem(productId: e.key, quantity: e.value))
        .toList();
  }

  @override
  Future<int?> getCurrentCartId(int userId) async {
    final carts = await _localDataSource.getCartsByUserId(userId);
    if (carts.isNotEmpty) {
      return carts.first.id;
    }
    return null;
  }

  @override
  Future<bool> addToCart(
    int? cartId,
    int productId,
    int quantity,
    int userId,
  ) async {
    try {
      if (cartId != null) {
        // Lấy cart hiện tại từ local
        final localCart = await _localDataSource.getCartById(cartId);
        if (localCart != null) {
          final cartItems = await _localDataSource.getCartItemsByCartId(cartId);

          // Tạo danh sách products cho API
          final products = cartItems
              .map(
                (item) => {
                  'productId': item.productId,
                  'quantity': item.quantity,
                },
              )
              .toList();

          // Kiểm tra sản phẩm đã tồn tại chưa
          final existingItem = await _localDataSource.getCartItemByProductId(
            cartId,
            productId,
          );

          if (existingItem != null) {
            // Update quantity
            products.removeWhere((p) => p['productId'] == productId);
            products.add({
              'productId': productId,
              'quantity': existingItem.quantity + quantity,
            });
          } else {
            // Add new product
            products.add({'productId': productId, 'quantity': quantity});
          }

          // API Call
          final updatedCart = await _remoteDataSource.updateCart(
            cartId: cartId,
            userId: userId,
            date: localCart.date,
            products: products,
          );

          // API success → Sync to Local DB
          await _localDataSource.syncCartItems(cartId, products);
          return true;
        }
      }

      // Tạo cart mới
      final products = [
        {'productId': productId, 'quantity': quantity},
      ];

      // API Call
      final newCart = await _remoteDataSource.createCart(
        userId: userId,
        products: products,
      );

      // API success → Save to Local DB
      await _localDataSource.insertCart(newCart.toEntity());
      await _localDataSource.syncCartItems(newCart.id, products);
      return true;
    } catch (e) {
      // API fail → Không lưu vào DB
      return false;
    }
  }

  @override
  Future<bool> updateQuantity(
    int cartId,
    int productId,
    int newQuantity,
  ) async {
    try {
      final localCart = await _localDataSource.getCartById(cartId);
      if (localCart == null) return false;

      final cartItems = await _localDataSource.getCartItemsByCartId(cartId);

      final products = cartItems
          .map(
            (item) => {
              'productId': item.productId,
              'quantity': item.productId == productId
                  ? newQuantity
                  : item.quantity,
            },
          )
          .toList();

      // API Call
      await _remoteDataSource.updateCart(
        cartId: cartId,
        userId: localCart.userId,
        date: localCart.date,
        products: products,
      );

      // API success → Update Local DB
      final existingItem = await _localDataSource.getCartItemByProductId(
        cartId,
        productId,
      );
      if (existingItem != null) {
        await _localDataSource.updateCartItem(
          CartItemEntity(
            id: existingItem.id,
            cartId: cartId,
            productId: productId,
            quantity: newQuantity,
          ),
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFromCart(int cartId, int productId) async {
    try {
      final localCart = await _localDataSource.getCartById(cartId);
      if (localCart == null) return false;

      final cartItems = await _localDataSource.getCartItemsByCartId(cartId);

      final products = cartItems
          .where((item) => item.productId != productId)
          .map(
            (item) => {'productId': item.productId, 'quantity': item.quantity},
          )
          .toList();

      // API Call
      await _remoteDataSource.updateCart(
        cartId: cartId,
        userId: localCart.userId,
        date: localCart.date,
        products: products,
      );

      // API success → Delete from Local DB
      await _localDataSource.deleteCartItemByProductId(cartId, productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> syncCartFromApi(int userId) async {
    try {
      // Lấy tất cả carts từ API
      final remoteCarts = await _remoteDataSource.getCarts();
      final userCarts = remoteCarts
          .where((cart) => cart.userId == userId)
          .toList();

      // Xóa dữ liệu cũ trong Local DB
      await _localDataSource.deleteCartsByUserId(userId);

      // Sync carts mới vào Local DB
      for (var cart in userCarts) {
        await _localDataSource.insertCart(cart.toEntity());
        await _localDataSource.syncCartItems(cart.id, cart.products);
      }
    } catch (e) {
      // Không làm gì nếu sync fail
    }
  }
}
