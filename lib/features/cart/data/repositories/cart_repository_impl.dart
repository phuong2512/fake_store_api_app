import 'package:fake_store_api_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/models/cart_entity.dart';
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

    final cartIds = carts.map((c) => c.id).whereType<int>().toList();
    final cartItems = await _localDataSource.getCartItemsByCartIds(cartIds);

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
  Future<bool> addToCart(int productId, int quantity, int userId) async {
    try {
      // BƯỚC 1: Tự tìm cartId dựa trên userId
      final int? existingCartId = await getCurrentCartId(userId);

      if (existingCartId != null) {
        // TRƯỜNG HỢP 1: ĐÃ CÓ GIỎ HÀNG
        // Đây là logic cũ trong khối 'if (cartId != null)'
        // Chỉ cần thay 'cartId' bằng 'existingCartId'

        final localCart = await _localDataSource.getCartById(existingCartId);
        if (localCart != null) {
          final cartItems = await _localDataSource.getCartItemsByCartId(
            existingCartId,
          );

          final products = cartItems
              .map(
                (item) => {
                  'productId': item.productId,
                  'quantity': item.quantity,
                },
              )
              .toList();

          final existingItem = await _localDataSource.getCartItemByProductId(
            existingCartId, // Dùng existingCartId
            productId,
          );

          if (existingItem != null) {
            products.removeWhere((p) => p['productId'] == productId);
            products.add({
              'productId': productId,
              'quantity': existingItem.quantity + quantity,
            });
          } else {
            products.add({'productId': productId, 'quantity': quantity});
          }

          await _localDataSource.syncCartItems(existingCartId, products);
          return true;
        }
        // (Nếu localCart bị null vì lý do nào đó, code sẽ tự
        // chạy xuống logic "Tạo cart mới" bên dưới, vẫn an toàn)
      }

      // TRƯỜNG HỢP 2: CHƯA CÓ GIỎ HÀNG -> TẠO MỚI
      // Đây là logic cũ trong khối 'else' (khi cartId == null)

      final products = [
        {'productId': productId, 'quantity': quantity},
      ];

      final newCartFromApi = await _remoteDataSource.createCart(
        userId: userId,
        products: products,
      );

      final localCartEntity = CartEntity(
        userId: userId,
        date: newCartFromApi.date,
      );

      final int newLocalCartId = await _localDataSource.insertCart(
        localCartEntity,
      );
      await _localDataSource.syncCartItems(newLocalCartId, products);
      return true;
    } catch (e) {
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

      await _localDataSource.deleteCartItemByProductId(cartId, productId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> syncCartFromApi(int userId) async {
    try {
      final remoteCarts = await _remoteDataSource.getCarts();
      final userCarts = remoteCarts
          .where((cart) => cart.userId == userId)
          .toList();

      await _localDataSource.deleteCartsByUserId(userId);

      for (var cart in userCarts) {
        final localEntity = CartEntity(userId: cart.userId, date: cart.date);
        // LẤY ID MỚI TỪ LOCAL DB
        final newLocalId = await _localDataSource.insertCart(localEntity);

        // DÙNG ID MỚI ĐỂ SYNC
        await _localDataSource.syncCartItems(newLocalId, cart.products);
      }
    } catch (e) {
      // Xử lý lỗi
    }
  }
}
