import 'package:flutter/material.dart';

/// AppColors defines the semantic color palette for Spendly.
/// Designed with a luxury Neobank aesthetic: Nordic Indigo & Glacier Mint,
/// with Vanilla Mist light surfaces and Midnight Obsidian dark surfaces.
abstract class AppColors {
  // Primary Palette - Nordic Indigo
  static const Color primary = Color(0xFF4338CA); // Nordic Indigo
  static const Color primaryLight = Color(0xFF6366F1); // Vivid Indigo
  static const Color primaryDark = Color(0xFF1E1B4B); // Midnight Indigo

  // Accent & Secondary Palette - Glacier Mint
  static const Color glacier = Color(0xFF06B6D4); // Glacier Cyan
  static const Color glacierMint = Color(0xFF10B981); // Glacier Mint
  static const Color glacierLight = Color(0xFF38BDF8); // Ice Sky
  static const Color accent = Color(0xFF0D9488); // Deep Mint Teal
  static const Color mintHighlight = Color(0xFF34D399); // Radiant Mint

  // Status & Functional Colors
  static const Color success = Color(0xFF10B981); // Emerald Mint
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color error = Color(0xFFEF4444); // Crimson Red

  // Neutral Colors - Light Mode (Vanilla Mist / Soft Pearl)
  static const Color lightBackground = Color(0xFFF6F8FC); // Vanilla Mist
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEEF2F7);
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightBorder = Color(0xFFE2E8F0); // Subtle Border

  // Neutral Colors - Dark Mode (Midnight Obsidian)
  static const Color darkBackground = Color(0xFF090D16); // Deep Obsidian
  static const Color darkSurface = Color(0xFF131B2E); // Obsidian Card
  static const Color darkSurfaceVariant = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF26334D);

  // Category Colors (Refined & Harmonious)
  static const Color categoryFood = Color(0xFFF97316); // Amber Orange
  static const Color categoryTransport = Color(0xFF0284C7); // Glacier Blue
  static const Color categoryShopping = Color(0xFFEC4899); // Magenta Pink
  static const Color categoryBills = Color(0xFF8B5CF6); // Royal Violet
  static const Color categoryHealth = Color(0xFF10B981); // Glacier Mint
  static const Color categoryEducation = Color(0xFF4338CA); // Nordic Indigo
  static const Color categoryEntertainment = Color(0xFFF59E0B); // Golden Amber
  static const Color categoryTravel = Color(0xFF06B6D4); // Cyan Teal
  static const Color categoryOther = Color(0xFF64748B); // Cool Slate

  // Hero Card Gradients
  static const LinearGradient heroWalletGradient = LinearGradient(
    colors: [
      Color(0xFF312E81), // Deep Nordic Indigo
      Color(0xFF1E1B4B), // Midnight
      Color(0xFF0F766E), // Glacier Teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient glacierMintGradient = LinearGradient(
    colors: [
      Color(0xFF06B6D4), // Glacier
      Color(0xFF10B981), // Mint
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fabGradient = LinearGradient(
    colors: [
      Color(0xFF4338CA), // Nordic Indigo
      Color(0xFF06B6D4), // Glacier
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
