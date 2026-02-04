import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/products.dart';
import '../data/categories.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import './product_detail_screen.dart';
import './cart_screen.dart';
import './favorites_screen.dart';
import './categories_screen.dart';
import '../services/cart_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  List<Product> _favorites = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Product> get _filteredProducts {
    var products = ProductsData.products;

    // Filter by category
    if (_selectedCategory != 'All') {
      products = products.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      products = products.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return products;
  }

  void _toggleFavorite(Product product) {
    setState(() {
      if (_favorites.any((p) => p.id == product.id)) {
        _favorites.removeWhere((p) => p.id == product.id);
      } else {
        _favorites.add(product);
      }
    });
  }

  bool _isFavorite(Product product) {
    return _favorites.any((p) => p.id == product.id);
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ShopVerse',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            Text(
              'Discover amazing products',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Text(cartService.itemCount.toString()),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: cartService,
                    child: const CartScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Badge(
              label: Text(_favorites.length.toString()),
              child: const Icon(Icons.favorite_outline),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favorites: _favorites,
                    onToggleFavorite: _toggleFavorite,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoriesScreen(
                            categories: CategoriesData.categories,
                            onCategorySelect: (category) {
                              setState(() {
                                _selectedCategory = category.name;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories Horizontal List
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // "All" category
                  CategoryCard(
                    category: const Category(
                      id: '0',
                      name: 'All',
                      icon: '🔥',
                      color: Colors.deepPurple,
                      imageUrl: '',
                    ),
                    isSelected: _selectedCategory == 'All',
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'All';
                      });
                    },
                  ),

                  // Other categories
                  ...CategoriesData.categories.map((category) {
                    return CategoryCard(
                      category: category,
                      isSelected: _selectedCategory == category.name,
                      onTap: () {
                        setState(() {
                          _selectedCategory = category.name;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Featured Products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory == 'All'
                        ? 'Featured Products'
                        : '${_selectedCategory} Products',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_filteredProducts.length} items',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductCard(
                    product: product,
                    isFavorite: _isFavorite(product),
                    onFavoriteToggle: () => _toggleFavorite(product),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: cartService,
                            child: ProductDetailScreen(
                              product: product,
                              isFavorite: _isFavorite(product),
                              onToggleFavorite: () => _toggleFavorite(product),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_filled,
                      color: Colors.deepPurple,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                // Categories
                IconButton(
                  icon: const Icon(Icons.widgets_outlined, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoriesScreen(
                          categories: CategoriesData.categories,
                          onCategorySelect: (category) {
                            setState(() {
                              _selectedCategory = category.name;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),

                // Cart
                Badge(
                  label: Text(cartService.itemCount.toString()),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: cartService,
                            child: const CartScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Profile
                IconButton(
                  icon: const Icon(Icons.person_outline, size: 24),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}