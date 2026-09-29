import 'package:flutter/material.dart';

/// AppColors defines the semantic color palette for Spendly.
/// Designed with a modern financial aesthetic: deep indigo primary,
/// teal accent, soft surfaces, and distinct category colors.
abstract class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryLight = Color(0xFF6366F1); // Indigo 500
  static const Color primaryDark = Color(0xFF3730A3); // Indigo 800

  // Accent Palette
  static const Color accent = Color(0xFF0EA5E9); // Sky 500
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Red 500

  // Neutral Colors - Light Mode
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200

  // Neutral Colors - Dark Mode
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkBorder = Color(0xFF334155); // Slate 700

  // Category Colors
  static const Color categoryFood = Color(0xFFF97316); // Orange
  static const Color categoryTransport = Color(0xFF0284C7); // Light Blue
  static const Color categoryShopping = Color(0xFFEC4899); // Pink
  static const Color categoryBills = Color(0xFF8B5CF6); // Purple
  static const Color categoryHealth = Color(0xFF10B981); // Emerald
  static const Color categoryEducation = Color(0xFF6366F1); // Indigo
  static const Color categoryEntertainment = Color(0xFFF59E0B); // Amber
  static const Color categoryTravel = Color(0xFF14B8A6); // Teal
  static const Color categoryOther = Color(0xFF64748B); // Slate
}
