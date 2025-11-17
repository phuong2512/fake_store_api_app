import 'package:dio/dio.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/sync_cart_from_api.dart';
import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import 'package:fake_store_api_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fake_store_api_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fake_store_api_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fake_store_api_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:fake_store_api_app/features/auth/domain/usecases/login_user.dart';
import 'package:fake_store_api_app/features/auth/domain/usecases/get_user.dart';
import 'package:fake_store_api_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:fake_store_api_app/features/product/data/datasources/product_local_data_source.dart';
import 'package:fake_store_api_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:fake_store_api_app/features/product/domain/repositories/product_repository.dart';
import 'package:fake_store_api_app/features/product/domain/usecases/get_products.dart';
import 'package:fake_store_api_app/features/product/domain/usecases/get_product_by_id.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_list_controller.dart';
import 'package:fake_store_api_app/features/product/presentation/controller/product_detail_controller.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:fake_store_api_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:fake_store_api_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_user_cart.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/get_current_cart_id.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/update_quantity.dart';
import 'package:fake_store_api_app/features/cart/domain/usecases/remove_from_cart.dart';
import 'package:fake_store_api_app/features/cart/presentation/controller/cart_controller.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Database
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  getIt.registerSingleton<AppDatabase>(database);

  // Dio instances
  final authDio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final productDio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final cartDio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // ====== AUTH ======
  getIt.registerLazySingleton(() => AuthRemoteDataSource(authDio));
  getIt.registerLazySingleton(() => AuthLocalDataSource(database.userDao));

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetUser(getIt<AuthRepository>()));

  getIt.registerFactory(
    () => AuthController(
      loginUser: getIt<LoginUser>(),
      getUser: getIt<GetUser>(),
    ),
  );

  // ====== PRODUCT ======
  getIt.registerLazySingleton(() => ProductRemoteDataSource(productDio));
  getIt.registerLazySingleton(
    () => ProductLocalDataSource(database.productDao),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt<ProductRemoteDataSource>(),
      getIt<ProductLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(() => GetProducts(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => GetProductById(getIt<ProductRepository>()));

  getIt.registerFactory(
    () => ProductListController(getProducts: getIt<GetProducts>()),
  );

  getIt.registerFactory(
    () => ProductDetailController(cartRepository: getIt<CartRepository>()),
  );

  // ====== CART ======
  getIt.registerLazySingleton(() => CartRemoteDataSource(cartDio));
  getIt.registerLazySingleton(() => CartLocalDataSource(database.cartDao));

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      getIt<CartRemoteDataSource>(),
      getIt<CartLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton(
    () => GetUserCart(getIt<CartRepository>(), getIt<ProductRepository>()),
  );
  getIt.registerLazySingleton(() => GetCurrentCartId(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => UpdateQuantity(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => SyncCartFromApi(getIt<CartRepository>()));

  getIt.registerFactory(
    () => CartController(
      getUserCart: getIt<GetUserCart>(),
      getCurrentCartId: getIt<GetCurrentCartId>(),
      updateQuantity: getIt<UpdateQuantity>(),
      removeFromCart: getIt<RemoveFromCart>(),
      syncCartFromApi: getIt<SyncCartFromApi>(),
    ),
  );
}
