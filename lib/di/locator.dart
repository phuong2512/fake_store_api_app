import 'package:fake_store_api_app/controllers/auth_controller.dart';
import 'package:fake_store_api_app/controllers/cart_controller.dart';
import 'package:fake_store_api_app/controllers/product_controller.dart';
import 'package:fake_store_api_app/interfaces/auth_interface.dart';
import 'package:fake_store_api_app/interfaces/cart_interface.dart';
import 'package:fake_store_api_app/interfaces/product_interface.dart';
import 'package:fake_store_api_app/repositories/auth_repository.dart';
import 'package:fake_store_api_app/repositories/cart_repository.dart';
import 'package:fake_store_api_app/repositories/product_repository.dart';
import 'package:fake_store_api_app/services/auth_service.dart';
import 'package:fake_store_api_app/services/cart_service.dart';
import 'package:fake_store_api_app/services/product_service.dart';
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
