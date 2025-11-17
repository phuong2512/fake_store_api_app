class Cart {
  final int id;
  final int userId;
  final String date;
  final List<Map<String, dynamic>> products;

  Cart({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
  });
}
