import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

/// Interactive 3-slide visual onboarding walkthrough for Spendly.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onGetStarted;
  final bool isReplay;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
    this.isReplay = false,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _slides = const [
    _OnboardingItem(
      badge: 'SMART CATEGORIZATION',
      title: 'Track Every Rupee\nwith Precision',
      description:
          'Effortlessly log daily expenses across 9 dedicated categories with real-time balance updates.',
      icon: Icons.account_tree_rounded,
      accentColor: AppColors.glacier,
    ),
    _OnboardingItem(
      badge: 'INTERACTIVE ANALYTICS',
      title: 'Understand Where\nYour Money Flows',
      description:
          'Dynamic doughnut charts and monthly breakdown metrics give you instant financial clarity.',
      icon: Icons.donut_large_rounded,
      accentColor: AppColors.glacierMint,
    ),
    _OnboardingItem(
      badge: 'PRIVACY & CLOUD SYNC',
      title: 'Private, Secure &\nAlways In Sync',
      description:
          'Your financial vault is isolated with strict security rules, real-time Firestore sync, and offline support.',
      icon: Icons.verified_user_rounded,
      accentColor: AppColors.primaryLight,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      widget.onGetStarted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final subtextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.lg,
                vertical: AppStyles.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Mini Mark
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.glacier.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/icon/app_icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppStyles.sm),
                      Text(
                        'Spendly',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),

                  // Skip or Close Button
                  if (widget.isReplay)
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    )
                  else if (_currentPage < _slides.length - 1)
                    TextButton(
                      onPressed: widget.onGetStarted,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: subtextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            // Middle Carousel (Fully Scroll-Safe to prevent any RenderFlex overflow)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.lg,
                        vertical: AppStyles.xs,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Visual Interactive Illustration Card
                          _buildSlideVisual(index, isDark, surfaceColor),

                          const SizedBox(height: AppStyles.md),

                          // Badge Pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppStyles.md,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: slide.accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: slide.accentColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              slide.badge,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: slide.accentColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: AppStyles.sm),

                          // Title
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              height: 1.2,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: AppStyles.xs),

                          // Subtitle
                          Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: subtextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Footer
            Padding(
              padding: const EdgeInsets.all(AppStyles.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Animated Page Dot Indicators
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) {
                        final isSelected = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: isSelected ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppColors.glacierMintGradient
                                : null,
                            color: isSelected
                                ? null
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.black.withValues(alpha: 0.1)),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),

                  // Next / Get Started Action Button
                  ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 46),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.md,
                        vertical: AppStyles.xs,
                      ),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPage == _slides.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          _currentPage == _slides.length - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.chevron_right_rounded,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideVisual(int index, bool isDark, Color surfaceColor) {
    switch (index) {
      case 0:
        return _buildCategoriesVisual(isDark, surfaceColor);
      case 1:
        return _buildAnalyticsVisual(isDark, surfaceColor);
      case 2:
      default:
        return _buildSecurityVisual(isDark, surfaceColor);
    }
  }

  /// Slide 1 Graphic: Floating Category Pills & Smart Expense Cards
  Widget _buildCategoriesVisual(bool isDark, Color surfaceColor) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.symmetric(horizontal: AppStyles.md, vertical: AppStyles.xs),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMiniTransactionRow(
            icon: Icons.restaurant_rounded,
            title: 'Food & Dining',
            date: 'Today, 1:30 PM',
            amount: 'Rs. 1,450.00',
            categoryColor: AppColors.categoryFood,
          ),
          _buildMiniTransactionRow(
            icon: Icons.directions_car_rounded,
            title: 'Fuel & Transport',
            date: 'Yesterday',
            amount: 'Rs. 850.00',
            categoryColor: AppColors.categoryTransport,
          ),
          _buildMiniTransactionRow(
            icon: Icons.shopping_bag_rounded,
            title: 'Supermarket Shopping',
            date: '28 Sep',
            amount: 'Rs. 3,240.00',
            categoryColor: AppColors.categoryShopping,
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTransactionRow({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required Color categoryColor,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: categoryColor, size: 18),
        ),
        const SizedBox(width: AppStyles.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
        Text(
          '-$amount',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  /// Slide 2 Graphic: Doughnut Chart & Insight Card
  Widget _buildAnalyticsVisual(bool isDark, Color surfaceColor) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(AppStyles.md),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
      ),
      child: Row(
        children: [
          // Circular Donut Visual
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 86,
                height: 86,
                child: CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 12,
                  strokeCap: StrokeCap.round,
                  backgroundColor: AppColors.glacier.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.glacierMint),
                ),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pie_chart_rounded, color: AppColors.glacierMint, size: 20),
                  SizedBox(height: 2),
                  Text(
                    '72%',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: AppStyles.md),
          // Analytics Stat Badges
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'September Budget',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Rs. 54,200',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_down_rounded, size: 13, color: AppColors.success),
                      SizedBox(width: 4),
                      Text(
                        '14% under budget',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Slide 3 Graphic: Security Shield, Cloud Sync & Modern Privacy
  Widget _buildSecurityVisual(bool isDark, Color surfaceColor) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(AppStyles.md),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.glacierMintGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.glacierMint.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: AppStyles.sm),
          const Text(
            'User-Level Data Isolation',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Text(
            'Protected by Cloud Firestore Security Rules',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: AppStyles.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_done_rounded, size: 12, color: AppColors.primaryLight),
                SizedBox(width: 4),
                Text(
                  'Cloud Synced & Offline Ready',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String badge;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;

  const _OnboardingItem({
    required this.badge,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}
