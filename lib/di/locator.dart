import 'package:fake_store_api_app/views/auth/auth_controller.dart';
import 'package:fake_store_api_app/views/cart/cart_controller.dart';
import 'package:fake_store_api_app/views/product/product_controller.dart';
import 'package:fake_store_api_app/views/auth/auth_interface.dart';
import 'package:fake_store_api_app/views/cart/cart_interface.dart';
import 'package:fake_store_api_app/views/product/product_interface.dart';
import 'package:fake_store_api_app/views/auth/auth_repository.dart';
import 'package:fake_store_api_app/views/cart/cart_repository.dart';
import 'package:fake_store_api_app/views/product/product_repository.dart';
import 'package:fake_store_api_app/views/auth/auth_service.dart';
import 'package:fake_store_api_app/views/cart/cart_service.dart';
import 'package:fake_store_api_app/views/product/product_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // services
  getIt.registerLazySingleton<AuthInterface>(() => AuthService());
  getIt.registerLazySingleton<ProductInterface>(() => ProductService());
  getIt.registerLazySingleton<CartInterface>(() => CartService());

  // repo
  getIt.registerLazySingleton(
    () => AuthRepository(getIt<AuthInterface>()),
  );
  getIt.registerLazySingleton(
    () => ProductRepository(getIt<ProductInterface>()),
  );
  getIt.registerLazySingleton(
    () => CartRepository(getIt<CartInterface>(), getIt<ProductInterface>()),
  );

  // controller
  getIt.registerLazySingleton(() => AuthController(getIt<AuthRepository>()));
  getIt.registerFactory(() => ProductController(getIt<ProductRepository>()));
  getIt.registerFactory(() => CartController(getIt<CartRepository>()));
}
