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
        _userEntityInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password
                }),
        _userEntityUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password
                }),
        _userEntityDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (UserEntity item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserEntity> _userEntityInsertionAdapter;

  final UpdateAdapter<UserEntity> _userEntityUpdateAdapter;

  final DeletionAdapter<UserEntity> _userEntityDeletionAdapter;

  @override
  Future<UserEntity?> getUserByUsername(String username) async {
    return _queryAdapter.query('SELECT * FROM users WHERE username = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
            id: row['id'] as int,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [username]);
  }

  @override
  Future<UserEntity?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserEntity(
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
  Future<void> insertUser(UserEntity user) async {
    await _userEntityInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    await _userEntityUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(UserEntity user) async {
    await _userEntityDeletionAdapter.delete(user);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productEntityInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (ProductEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image
                }),
        _ratingEntityInsertionAdapter = InsertionAdapter(
            database,
            'ratings',
            (RatingEntity item) => <String, Object?>{
                  'id': item.id,
                  'productId': item.productId,
                  'rate': item.rate,
                  'count': item.count
                }),
        _productEntityUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['id'],
            (ProductEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image
                }),
        _ratingEntityUpdateAdapter = UpdateAdapter(
            database,
            'ratings',
            ['id'],
            (RatingEntity item) => <String, Object?>{
                  'id': item.id,
                  'productId': item.productId,
                  'rate': item.rate,
                  'count': item.count
                }),
        _productEntityDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['id'],
            (ProductEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'price': item.price,
                  'description': item.description,
                  'category': item.category,
                  'image': item.image
                }),
        _ratingEntityDeletionAdapter = DeletionAdapter(
            database,
            'ratings',
            ['id'],
            (RatingEntity item) => <String, Object?>{
                  'id': item.id,
                  'productId': item.productId,
                  'rate': item.rate,
                  'count': item.count
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductEntity> _productEntityInsertionAdapter;

  final InsertionAdapter<RatingEntity> _ratingEntityInsertionAdapter;

  final UpdateAdapter<ProductEntity> _productEntityUpdateAdapter;

  final UpdateAdapter<RatingEntity> _ratingEntityUpdateAdapter;

  final DeletionAdapter<ProductEntity> _productEntityDeletionAdapter;

  final DeletionAdapter<RatingEntity> _ratingEntityDeletionAdapter;

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM products',
        mapper: (Map<String, Object?> row) => ProductEntity(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String));
  }

  @override
  Future<ProductEntity?> getProductById(int id) async {
    return _queryAdapter.query('SELECT * FROM products WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ProductEntity(
            id: row['id'] as int,
            title: row['title'] as String,
            price: row['price'] as double,
            description: row['description'] as String,
            category: row['category'] as String,
            image: row['image'] as String),
        arguments: [id]);
  }

  @override
  Future<List<ProductEntity>> getProductsByIds(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE id IN (' + _sqliteVariablesForIds + ')',
        mapper: (Map<String, Object?> row) => ProductEntity(
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
  Future<RatingEntity?> getRatingByProductId(int productId) async {
    return _queryAdapter.query('SELECT * FROM ratings WHERE productId = ?1',
        mapper: (Map<String, Object?> row) => RatingEntity(
            id: row['id'] as int?,
            productId: row['productId'] as int,
            rate: row['rate'] as double,
            count: row['count'] as int),
        arguments: [productId]);
  }

  @override
  Future<void> insertProduct(ProductEntity product) async {
    await _productEntityInsertionAdapter.insert(
        product, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertProducts(List<ProductEntity> products) async {
    await _productEntityInsertionAdapter.insertList(
        products, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRating(RatingEntity rating) async {
    await _ratingEntityInsertionAdapter.insert(
        rating, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertRatings(List<RatingEntity> ratings) async {
    await _ratingEntityInsertionAdapter.insertList(
        ratings, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await _productEntityUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRating(RatingEntity rating) async {
    await _ratingEntityUpdateAdapter.update(rating, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(ProductEntity product) async {
    await _productEntityDeletionAdapter.delete(product);
  }

  @override
  Future<void> deleteRating(RatingEntity rating) async {
    await _ratingEntityDeletionAdapter.delete(rating);
  }
}

class _$CartDao extends CartDao {
  _$CartDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cartEntityInsertionAdapter = InsertionAdapter(
            database,
            'carts',
            (CartEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': item.date
                }),
        _cartItemEntityInsertionAdapter = InsertionAdapter(
            database,
            'cart_items',
            (CartItemEntity item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity
                }),
        _cartEntityUpdateAdapter = UpdateAdapter(
            database,
            'carts',
            ['id'],
            (CartEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': item.date
                }),
        _cartItemEntityUpdateAdapter = UpdateAdapter(
            database,
            'cart_items',
            ['id'],
            (CartItemEntity item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity
                }),
        _cartEntityDeletionAdapter = DeletionAdapter(
            database,
            'carts',
            ['id'],
            (CartEntity item) => <String, Object?>{
                  'id': item.id,
                  'userId': item.userId,
                  'date': item.date
                }),
        _cartItemEntityDeletionAdapter = DeletionAdapter(
            database,
            'cart_items',
            ['id'],
            (CartItemEntity item) => <String, Object?>{
                  'id': item.id,
                  'cartId': item.cartId,
                  'productId': item.productId,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CartEntity> _cartEntityInsertionAdapter;

  final InsertionAdapter<CartItemEntity> _cartItemEntityInsertionAdapter;

  final UpdateAdapter<CartEntity> _cartEntityUpdateAdapter;

  final UpdateAdapter<CartItemEntity> _cartItemEntityUpdateAdapter;

  final DeletionAdapter<CartEntity> _cartEntityDeletionAdapter;

  final DeletionAdapter<CartItemEntity> _cartItemEntityDeletionAdapter;

  @override
  Future<List<CartEntity>> getCartsByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM carts WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => CartEntity(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            date: row['date'] as String),
        arguments: [userId]);
  }

  @override
  Future<CartEntity?> getCartById(int cartId) async {
    return _queryAdapter.query('SELECT * FROM carts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CartEntity(
            id: row['id'] as int?,
            userId: row['userId'] as int,
            date: row['date'] as String),
        arguments: [cartId]);
  }

  @override
  Future<List<CartItemEntity>> getCartItemsByCartId(int cartId) async {
    return _queryAdapter.queryList('SELECT * FROM cart_items WHERE cartId = ?1',
        mapper: (Map<String, Object?> row) => CartItemEntity(
            id: row['id'] as int?,
            cartId: row['cartId'] as int,
            productId: row['productId'] as int,
            quantity: row['quantity'] as int),
        arguments: [cartId]);
  }

  @override
  Future<List<CartItemEntity>> getCartItemsByCartIds(List<int> cartIds) async {
    const offset = 1;
    final _sqliteVariablesForCartIds =
        Iterable<String>.generate(cartIds.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM cart_items WHERE cartId IN (' +
            _sqliteVariablesForCartIds +
            ')',
        mapper: (Map<String, Object?> row) => CartItemEntity(
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
  Future<CartItemEntity?> getCartItemByProductId(
    int cartId,
    int productId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM cart_items WHERE cartId = ?1 AND productId = ?2',
        mapper: (Map<String, Object?> row) => CartItemEntity(
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
  Future<int> insertCart(CartEntity cart) {
    return _cartEntityInsertionAdapter.insertAndReturnId(
        cart, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertCartItem(CartItemEntity cartItem) async {
    await _cartItemEntityInsertionAdapter.insert(
        cartItem, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCart(CartEntity cart) async {
    await _cartEntityUpdateAdapter.update(cart, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCartItem(CartItemEntity cartItem) async {
    await _cartItemEntityUpdateAdapter.update(
        cartItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCart(CartEntity cart) async {
    await _cartEntityDeletionAdapter.delete(cart);
  }

  @override
  Future<void> deleteCartItem(CartItemEntity cartItem) async {
    await _cartItemEntityDeletionAdapter.delete(cartItem);
  }
}
