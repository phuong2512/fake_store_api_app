import 'package:fake_store_api_app/features/auth/data/datasources/auth_data_source.dart';
import 'package:fake_store_api_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fake_store_api_app/features/auth/domain/usecases/get_user.dart';
import 'package:fake_store_api_app/features/auth/domain/usecases/login_user.dart';
import 'package:fake_store_api_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/add_to_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_current_cart_id.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_user_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/update_quantity.dart';
import 'package:fake_store_api_app/features/cart/presentation/controller/cart_controller.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_data_source.dart';
import 'package:fake_store_api_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';
import 'package:fake_store_api_app/features/product/domain/usecases/get_product_by_id.dart';
import 'package:fake_store_api_app/features/product/domain/usecases/get_products.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_controller.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // --- DataSources ---
  // (Ghi chú: Đổi tên từ 'Service' thành 'DataSource' cho nhất quán)
  getIt.registerLazySingleton(() => AuthDataSource());
  getIt.registerLazySingleton(() => ProductDataSource());
  getIt.registerLazySingleton(() => CartDataSource());

  // --- Repositories ---
  // (Ghi chú: Tiêm (Inject) Abstraction, nhưng đăng ký Implementation)
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthDataSource>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(getIt<ProductDataSource>()),
  );
  getIt.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(
      getIt<CartDataSource>(),
      getIt<ProductDataSource>(), // Cart repo cần product service
    ),
  );

  // --- Usecases ---
  // (Ghi chú: Lớp Domain mới, chứa logic nghiệp vụ)
  // Auth
  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetUser(getIt<AuthRepository>()));

  // Product
  getIt.registerLazySingleton(() => GetProducts(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => GetProductById(getIt<ProductRepository>()));

  // Cart
  getIt.registerLazySingleton(() => GetUserCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => GetCurrentCartId(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => AddToCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => UpdateQuantity(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt<CartRepository>()));

  // --- Controllers ---
  // (Ghi chú: Dùng 'registerFactory' để tạo mới mỗi lần gọi)
  getIt.registerFactory(
        () => AuthController(
      loginUser: getIt<LoginUser>(),
      getUser: getIt<GetUser>(),
    ),
  );
  getIt.registerFactory(
        () => ProductController(
      getProducts: getIt<GetProducts>(),
    ),
  );
  getIt.registerFactory(
        () => CartController(
      getUserCart: getIt<GetUserCart>(),
      getCurrentCartId: getIt<GetCurrentCartId>(),
      addToCart: getIt<AddToCart>(),
      updateQuantity: getIt<UpdateQuantity>(),
      removeFromCart: getIt<RemoveFromCart>(),
    ),
  );
}