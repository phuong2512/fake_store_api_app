import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/services/auth_service.dart';
import 'package:fake_store_api_app/services/cart_service.dart';
import 'package:fake_store_api_app/services/product_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerLazySingleton<AuthController>(
    () => AuthController(getIt<AuthService>()),
  );

  getIt.registerLazySingleton<ProductService>(() => ProductService());
  getIt.registerLazySingleton<ProductController>(
    () => ProductController(getIt<ProductService>()),
  );

  getIt.registerLazySingleton<CartService>(() => CartService());
  getIt.registerLazySingleton<CartController>(
    () => CartController(getIt<CartService>()),
  );
}
