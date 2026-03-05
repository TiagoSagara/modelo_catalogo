import 'package:intl/intl.dart';

class Product {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  final int stock;
  final String category;
  final DateTime updateDate;

  Product({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.stock,
    required this.category,
    required this.updateDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final dateString = json['meta']['updatedAt'] as String;
    final dateParsed = DateTime.parse(dateString);

    return Product(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      category: json['category'],
      updateDate: dateParsed,
    );
  }

  String get formattedUpdateDate => DateFormat('dd/MM/yyyy').format(updateDate);
}
