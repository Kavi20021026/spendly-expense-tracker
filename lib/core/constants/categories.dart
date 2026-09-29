import 'package:flutter/material.dart';
import '../../models/category.dart';
import 'app_colors.dart';

/// Predefined expense categories with dedicated icons and colors.
abstract class AppCategories {
  static const Category food = Category(
    id: 'food',
    name: 'Food',
    icon: Icons.restaurant_rounded,
    color: AppColors.categoryFood,
  );

  static const Category transport = Category(
    id: 'transport',
    name: 'Transport',
    icon: Icons.directions_bus_rounded,
    color: AppColors.categoryTransport,
  );

  static const Category shopping = Category(
    id: 'shopping',
    name: 'Shopping',
    icon: Icons.shopping_bag_rounded,
    color: AppColors.categoryShopping,
  );

  static const Category bills = Category(
    id: 'bills',
    name: 'Bills',
    icon: Icons.receipt_long_rounded,
    color: AppColors.categoryBills,
  );

  static const Category health = Category(
    id: 'health',
    name: 'Health',
    icon: Icons.medical_services_rounded,
    color: AppColors.categoryHealth,
  );

  static const Category education = Category(
    id: 'education',
    name: 'Education',
    icon: Icons.school_rounded,
    color: AppColors.categoryEducation,
  );

  static const Category entertainment = Category(
    id: 'entertainment',
    name: 'Entertainment',
    icon: Icons.movie_rounded,
    color: AppColors.categoryEntertainment,
  );

  static const Category travel = Category(
    id: 'travel',
    name: 'Travel',
    icon: Icons.flight_takeoff_rounded,
    color: AppColors.categoryTravel,
  );

  static const Category other = Category(
    id: 'other',
    name: 'Other',
    icon: Icons.more_horiz_rounded,
    color: AppColors.categoryOther,
  );

  static const List<Category> all = [
    food,
    transport,
    shopping,
    bills,
    health,
    education,
    entertainment,
    travel,
    other,
  ];

  /// Resolves a category string/ID to a [Category] object.
  /// Defaults to [other] if category is not recognized.
  static Category fromNameOrId(String identifier) {
    final normalized = identifier.trim().toLowerCase();
    return all.firstWhere(
      (cat) =>
          cat.id.toLowerCase() == normalized ||
          cat.name.toLowerCase() == normalized,
      orElse: () => other,
    );
  }
}
