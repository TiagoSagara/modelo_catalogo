class Product {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final int stock;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.stock,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      category: json['category'],
    );
  }
}
