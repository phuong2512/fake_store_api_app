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
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthInterface>()),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(getIt<ProductInterface>()),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(getIt<CartInterface>(), getIt<ProductInterface>()),
  );
}
