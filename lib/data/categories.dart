import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoriesData {
  static List<Category> categories = [
    Category(
      id: '1',
      name: 'Electronics',
      icon: '📱',
      color: Colors.blue,
      imageUrl: 'https://images.unsplash.com/photo-1498049794561-7780e7231661',
    ),
    Category(
      id: '2',
      name: 'Fashion',
      icon: '👕',
      color: Colors.pink,
      imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050',
    ),
    Category(
      id: '3',
      name: 'Home',
      icon: '🏠',
      color: Colors.amber,
      imageUrl: 'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6',
    ),
    Category(
      id: '4',
      name: 'Sports',
      icon: '⚽',
      color: Colors.green,
      imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211',
    ),
    Category(
      id: '5',
      name: 'Books',
      icon: '📚',
      color: Colors.purple,
      imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
    ),
    Category(
      id: '6',
      name: 'Beauty',
      icon: '💄',
      color: Colors.red,
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9',
    ),
    Category(
      id: '7',
      name: 'Toys',
      icon: '🧸',
      color: Colors.orange,
      imageUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1',
    ),
    Category(
      id: '8',
      name: 'Automotive',
      icon: '🚗',
      color: Colors.blueGrey,
      imageUrl: 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c',
    ),
  ];
}