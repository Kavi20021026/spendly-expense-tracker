import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_styles.dart';
import 'analytics/analytics_screen.dart';
import 'expenses/add_expense_screen.dart';
import 'expenses/expenses_screen.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';

/// MainShell manages bottom navigation and tab switching with a modern Fintech aesthetic.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<Widget> pages = [
      HomeScreen(
        onNavigateToExpenses: () {
          setState(() {
            _currentIndex = 1; // Switch to Expenses Tab
          });
        },
      ),
      const ExpensesScreen(),
      const AnalyticsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      floatingActionButton: Container(
        height: 58,
        width: 58,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.fabGradient,
          boxShadow: AppStyles.glowGlacier,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(29),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddExpenseScreen(),
                ),
              );
            },
            child: const Center(
              child: Icon(Icons.add_rounded, size: 32, color: Colors.white),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        indicatorColor: isDark
            ? AppColors.primary.withValues(alpha: 0.35)
            : AppColors.primary.withValues(alpha: 0.12),
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: Icon(Icons.pie_chart_rounded, color: AppColors.primary),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded, color: AppColors.primary),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
