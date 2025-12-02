import 'dart:async';

import 'package:fake_store_api_app/core/database/cart_item_converter.dart';
import 'package:fake_store_api_app/core/database/rating_converter.dart';
import 'package:fake_store_api_app/core/models/cart.dart';
import 'package:fake_store_api_app/core/models/product.dart';
import 'package:fake_store_api_app/core/models/user.dart';
import 'package:fake_store_api_app/core/services/auth/user_dao.dart';
import 'package:fake_store_api_app/core/services/cart/cart_dao.dart';
import 'package:fake_store_api_app/core/services/product/product_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [UserModel, ProductModel, CartModel])
@TypeConverters([RatingConverter, CartItemsConverter])
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;

  ProductDao get productDao;

  CartDao get cartDao;
}
