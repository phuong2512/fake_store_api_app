import 'package:dio/dio.dart';
import 'package:fake_store_api_app/core/database/app_database.dart';
import 'package:fake_store_api_app/core/repositories/auth/auth_repository.dart';
import 'package:fake_store_api_app/core/repositories/cart/cart_repository.dart';
import 'package:fake_store_api_app/core/repositories/product/product_repository.dart';
import 'package:fake_store_api_app/core/services/auth/auth_api_service.dart';
import 'package:fake_store_api_app/core/services/auth/auth_database_service.dart';
import 'package:fake_store_api_app/core/services/cart/cart_api_service.dart';
import 'package:fake_store_api_app/core/services/cart/cart_database_service.dart';
import 'package:fake_store_api_app/core/services/product/product_api_service.dart';
import 'package:fake_store_api_app/core/services/product/product_database_service.dart';
import 'package:fake_store_api_app/core/use_cases/add_to_cart.dart';
import 'package:fake_store_api_app/core/use_cases/clear_cart.dart';
import 'package:fake_store_api_app/core/use_cases/get_current_cart_id.dart';
import 'package:fake_store_api_app/core/use_cases/get_products.dart';
import 'package:fake_store_api_app/core/use_cases/get_user.dart';
import 'package:fake_store_api_app/core/use_cases/get_user_cart.dart';
import 'package:fake_store_api_app/core/use_cases/log_in_user.dart';
import 'package:fake_store_api_app/core/use_cases/log_out_user.dart';
import 'package:fake_store_api_app/core/use_cases/remove_from_cart.dart';
import 'package:fake_store_api_app/core/use_cases/update_quantity.dart';
import 'package:fake_store_api_app/presentations/auth/login_controller.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/product/product_detail/product_detail_controller.dart';
import 'package:fake_store_api_app/presentations/product/product_list/product_list_controller.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();
  getIt.registerSingleton<AppDatabase>(database);

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

  /// Auth
  // Datasources
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiServiceImpl(dio: authDio),
  );
  getIt.registerLazySingleton<AuthDatabaseService>(
    () => AuthDatabaseServiceImpl(userDao: database.userDao),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthApiService>(),
      getIt<AuthDatabaseService>(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(() => LogInUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogOutUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetUser(getIt<AuthRepository>()));

  // Controllers
  getIt.registerFactory(
    () => LoginController(
      loginUser: getIt<LogInUser>(),
      getUser: getIt<GetUser>(),
    ),
  );

  /// product
  // Datasources
  getIt.registerLazySingleton<ProductApiService>(
    () => ProductApiServiceImpl(dio: productDio),
  );
  getIt.registerLazySingleton<ProductDatabaseService>(
    () => ProductDatabaseServiceImpl(productDao: database.productDao),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      getIt<ProductApiService>(),
      getIt<ProductDatabaseService>(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(() => GetProducts(getIt<ProductRepository>()));
  getIt.registerLazySingleton(() => GetUserCart(getIt<CartRepository>(), getIt<ProductRepository>()));

  // Controllers
  getIt.registerFactory(
    () => ProductListController(
      getProducts: getIt<GetProducts>(),
      logOutUser: getIt<LogOutUser>(),
    ),
  );

  getIt.registerFactory(
    () => ProductDetailController(
      getUserCart: getIt<GetUserCart>(),
      addToCart: getIt<AddToCart>(),
      getUser: getIt<GetUser>(),
    ),
  );

  /// cart
  // Datasources
  getIt.registerLazySingleton<CartApiService>(
    () => CartApiServiceImpl(dio: cartDio),
  );
  getIt.registerLazySingleton<CartDatabaseService>(
    () => CartDatabaseServiceImpl(cartDao: database.cartDao),
  );

  // Repositories
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      getIt<CartApiService>(),
      getIt<CartDatabaseService>(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(() => GetCurrentCartId(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => UpdateQuantity(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => RemoveFromCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => ClearCart(getIt<CartRepository>()));
  getIt.registerLazySingleton(() => AddToCart(getIt<CartRepository>()));

  // Controllers
  getIt.registerFactory(
    () => CartController(
      getUserCart: getIt<GetUserCart>(),
      getCurrentCartId: getIt<GetCurrentCartId>(),
      updateQuantity: getIt<UpdateQuantity>(),
      removeFromCart: getIt<RemoveFromCart>(),
      clearCart: getIt<ClearCart>(),
      getUser: getIt<GetUser>(),
    ),
  );
}
