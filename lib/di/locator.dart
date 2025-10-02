import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/interfaces/auth_interface.dart';
import 'package:fake_store_api_app/interfaces/cart_interface.dart';
import 'package:fake_store_api_app/interfaces/product_interface.dart';
import 'package:fake_store_api_app/services/auth_service.dart';
import 'package:fake_store_api_app/services/cart_service.dart';
import 'package:fake_store_api_app/services/product_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AuthInterface>(() => AuthService());
  getIt.registerLazySingleton<AuthController>(
    () => AuthController(getIt<AuthInterface>()),
  );

  getIt.registerLazySingleton<ProductInterface>(() => ProductService());
  getIt.registerLazySingleton<ProductController>(
    () => ProductController(getIt<ProductInterface>()),
  );

  getIt.registerLazySingleton<CartInterface>(() => CartService());
  getIt.registerLazySingleton<CartController>(
    () => CartController(getIt<CartInterface>(), getIt<ProductInterface>()),
  );
}
