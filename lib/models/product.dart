class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviews;
  final String imageUrl;
  final List<String> images;
  final String category;
  final bool isFavorite;
  final bool isNew;
  final int stock;
  final List<String> features;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice = 0,
    this.rating = 4.0,
    this.reviews = 0,
    required this.imageUrl,
    this.images = const [],
    required this.category,
    this.isFavorite = false,
    this.isNew = false,
    this.stock = 100,
    this.features = const [],
  });

  double get discountPercentage {
    if (originalPrice == 0) return 0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }

  bool get hasDiscount => originalPrice > 0 && originalPrice > price;
}