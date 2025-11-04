import 'package:fake_store_api_app/data/repositories/auth_repository_impl.dart';
import 'package:fake_store_api_app/data/repositories/cart_repository_impl.dart';
import 'package:fake_store_api_app/data/repositories/product_repository.dart';
import 'package:fake_store_api_app/data/repositories/product_repository_impl.dart';
import 'package:fake_store_api_app/presentations/auth/auth_controller.dart';
import 'package:fake_store_api_app/presentations/cart/cart_controller.dart';
import 'package:fake_store_api_app/presentations/product/product_controller.dart';
import 'package:fake_store_api_app/data/repositories/auth_repository.dart';
import 'package:fake_store_api_app/data/repositories/cart_repository.dart';
import 'package:fake_store_api_app/data/services/auth_service.dart';
import 'package:fake_store_api_app/data/services/cart_service.dart';
import 'package:fake_store_api_app/data/services/product_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<CartService>(() => CartService());
  getIt.registerLazySingleton<ProductService>(() => ProductService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthService>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(getIt<CartService>(), getIt<ProductService>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductService>()),
  );

  getIt.registerFactory<AuthController>(
    () => AuthController(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<CartController>(
    () => CartController(getIt<CartRepository>()),
  );
  getIt.registerFactory<ProductController>(
    () => ProductController(getIt<ProductRepository>()),
  );
}
