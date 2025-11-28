// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  ProductDao? _productDaoInstance;

  CartDao? _cartDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER NOT NULL, `username` TEXT NOT NULL, `password` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `products` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `price` REAL NOT NULL, `description` TEXT NOT NULL, `category` TEXT NOT NULL, `image` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ratings` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `productId` INTEGER NOT NULL, `rate` REAL NOT NULL, `count` INTEGER NOT NULL, FOREIGN KEY (`productId`) REFERENCES `products` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `carts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userId` INTEGER NOT NULL, `date` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `cart_items` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `cartId` INTEGER NOT NULL, `productId` INTEGER NOT NULL, `quantity` INTEGER NOT NULL, FOREIGN KEY (`cartId`) REFERENCES `carts` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  CartDao get cartDao {
    return _cartDaoInstance ??= _$CartDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userLocalModelInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password
                }),
        _userLocalModelUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (UserLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password
                }),
        _userLocalModelDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (UserLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserLocalModel> _userLocalModelInsertionAdapter;

  final UpdateAdapter<UserLocalModel> _userLocalModelUpdateAdapter;

  final DeletionAdapter<UserLocalModel> _userLocalModelDeletionAdapter;

  @override
  Future<UserLocalModel?> getUserByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM users WHERE username = ?1',
        mapper: (Map<String, Object?> row) => UserLocalModel(
            id: row['id'] as int,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [username]);
  }

  @override
  Future<UserLocalModel?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserLocalModel(
            id: row['id'] as int,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<void> insertUser(UserLocalModel user) async {
    await _userLocalModelInsertionAdapter.insert(
        user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(UserLocalModel user) async {
    await _userLocalModelUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(UserLocalModel user) async {
    await _userLocalModelDeletionAdapter.delete(user);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productLocalModelInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (ProductLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image
                }),
        _ratingLocalModelInsertionAdapter = InsertionAdapter(
            database,
            'ratings',
            (RatingLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'productId': item.productId,
                  'rate': item.rate,
                  'count': item.count
                }),
        _productLocalModelUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['id'],
            (ProductLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image
                }),
        _ratingLocalModelUpdateAdapter = UpdateAdapter(
            database,
            'ratings',
            ['id'],
            (RatingLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'productId': item.productId,
                  'rate': item.rate,
                  'count': item.count
                }),
        _productLocalModelDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['id'],
            (ProductLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image
                }),
        _ratingLocalModelDeletionAdapter = DeletionAdapter(
            database,
            'ratings',
            ['id'],
            (RatingLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'productId': item.productId,
                  'rate': item.rate,
                  'count': item.count
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductLocalModel> _productLocalModelInsertionAdapter;

  final InsertionAdapter<RatingLocalModel> _ratingLocalModelInsertionAdapter;

  final UpdateAdapter<ProductLocalModel> _productLocalModelUpdateAdapter;

  final UpdateAdapter<RatingLocalModel> _ratingLocalModelUpdateAdapter;

  final DeletionAdapter<ProductLocalModel> _productLocalModelDeletionAdapter;

  final DeletionAdapter<RatingLocalModel> _ratingLocalModelDeletionAdapter;

  @override
  Future<List<ProductLocalModel>> getAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM products',
        mapper: (Map<String, Object?> row) => ProductLocalModel(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String));
  }

  @override
  Future<ProductLocalModel?> getProductById(int id) async {
    return _queryAdapter.query('SELECT * FROM products WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ProductLocalModel(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String),
        arguments: [id]);
  }

  @override
  Future<List<ProductLocalModel>> getProductsByIds(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE id IN (' + _sqliteVariablesForIds + ')',
        mapper: (Map<String, Object?> row) => ProductLocalModel(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String),
        arguments: [...ids]);
  }

  @override
  Future<void> deleteAllProducts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM products');
  }

  @override
  Future<RatingLocalModel?> getRatingByProductId(int productId) async {
    return _queryAdapter.query('SELECT * FROM ratings WHERE productId = ?1',
        mapper: (Map<String, Object?> row) => RatingLocalModel(
            id: row['id'] as int?,
            productId: row['productId'] as int,
            rate: row['rate'] as double,
            count: row['count'] as int),
        arguments: [productId]);
  }

  @override
  Future<void> insertProduct(ProductLocalModel product) async {
    await _productLocalModelInsertionAdapter.insert(
        product, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertProducts(List<ProductLocalModel> products) async {
    await _productLocalModelInsertionAdapter.insertList(
        products, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRating(RatingLocalModel rating) async {
    await _ratingLocalModelInsertionAdapter.insert(
        rating, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRatings(List<RatingLocalModel> ratings) async {
    await _ratingLocalModelInsertionAdapter.insertList(
        ratings, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProduct(ProductLocalModel product) async {
    await _productLocalModelUpdateAdapter.update(
        product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRating(RatingLocalModel rating) async {
    await _ratingLocalModelUpdateAdapter.update(
        rating, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(ProductLocalModel product) async {
    await _productLocalModelDeletionAdapter.delete(product);
  }

  @override
  Future<void> deleteRating(RatingLocalModel rating) async {
    await _ratingLocalModelDeletionAdapter.delete(rating);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cartLocalModelInsertionAdapter = InsertionAdapter(
            database,
            'carts',
            (CartLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': item.date
                }),
        _cartItemLocalModelInsertionAdapter = InsertionAdapter(
            database,
            'cart_items',
            (CartItemLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity
                }),
        _cartLocalModelUpdateAdapter = UpdateAdapter(
            database,
            'carts',
            ['id'],
            (CartLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': item.date
                }),
        _cartItemLocalModelUpdateAdapter = UpdateAdapter(
            database,
            'cart_items',
            ['id'],
            (CartItemLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity
                }),
        _cartLocalModelDeletionAdapter = DeletionAdapter(
            database,
            'carts',
            ['id'],
            (CartLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': item.date
                }),
        _cartItemLocalModelDeletionAdapter = DeletionAdapter(
            database,
            'cart_items',
            ['id'],
            (CartItemLocalModel item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CartLocalModel> _cartLocalModelInsertionAdapter;

  final InsertionAdapter<CartItemLocalModel>
      _cartItemLocalModelInsertionAdapter;

  final UpdateAdapter<CartLocalModel> _cartLocalModelUpdateAdapter;

  final UpdateAdapter<CartItemLocalModel> _cartItemLocalModelUpdateAdapter;

  final DeletionAdapter<CartLocalModel> _cartLocalModelDeletionAdapter;

  final DeletionAdapter<CartItemLocalModel> _cartItemLocalModelDeletionAdapter;

  @override
  Future<List<CartLocalModel>> getCartsByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM carts WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => CartLocalModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            date: row['date'] as String),
        arguments: [userId]);
  }

  @override
  Future<CartLocalModel?> getCartById(int cartId) async {
    return _queryAdapter.query('SELECT * FROM carts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CartLocalModel(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            date: row['date'] as String),
        arguments: [cartId]);
  }

  @override
  Future<List<CartItemLocalModel>> getCartItemsByCartId(int cartId) async {
    return _queryAdapter.queryList('SELECT * FROM cart_items WHERE cartId = ?1',
        mapper: (Map<String, Object?> row) => CartItemLocalModel(
            id: row['id'] as int?,
            cartId: row['cartId'] as int,
            productId: row['productId'] as int,
            quantity: row['quantity'] as int),
        arguments: [cartId]);
  }

  @override
  Future<List<CartItemLocalModel>> getCartItemsByCartIds(
      List<int> cartIds) async {
    const offset = 1;
    final _sqliteVariablesForCartIds =
        Iterable<String>.generate(cartIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM cart_items WHERE cartId IN (' +
            _sqliteVariablesForCartIds +
            ')',
        mapper: (Map<String, Object?> row) => CartItemLocalModel(
            id: row['id'] as int?,
            cartId: row['cartId'] as int,
            productId: row['productId'] as int,
            quantity: row['quantity'] as int),
        arguments: [...cartIds]);
  }

  @override
  Future<void> deleteCartItemsByCartId(int cartId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM cart_items WHERE cartId = ?1',
        arguments: [cartId]);
  }

  @override
  Future<void> deleteCartItemByProductId(
    int cartId,
    int productId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM cart_items WHERE cartId = ?1 AND productId = ?2',
        arguments: [cartId, productId]);
  }

  @override
  Future<CartItemLocalModel?> getCartItemByProductId(
    int cartId,
    int productId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM cart_items WHERE cartId = ?1 AND productId = ?2',
        mapper: (Map<String, Object?> row) => CartItemLocalModel(
            id: row['id'] as int?,
            cartId: row['cartId'] as int,
            productId: row['productId'] as int,
            quantity: row['quantity'] as int),
        arguments: [cartId, productId]);
  }

  @override
  Future<void> deleteCartsByUserId(int userId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM carts WHERE userId = ?1',
        arguments: [userId]);
  }

  @override
  Future<int> insertCart(CartLocalModel cart) {
    return _cartLocalModelInsertionAdapter.insertAndReturnId(
        cart, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertCartItem(CartItemLocalModel cartItem) async {
    await _cartItemLocalModelInsertionAdapter.insert(
        cartItem, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCart(CartLocalModel cart) async {
    await _cartLocalModelUpdateAdapter.update(cart, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCartItem(CartItemLocalModel cartItem) async {
    await _cartItemLocalModelUpdateAdapter.update(
        cartItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCart(CartLocalModel cart) async {
    await _cartLocalModelDeletionAdapter.delete(cart);
  }

  @override
  Future<void> deleteCartItem(CartItemLocalModel cartItem) async {
    await _cartItemLocalModelDeletionAdapter.delete(cartItem);
  }
}
