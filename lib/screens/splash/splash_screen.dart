import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

/// Animated Neobank Splash Screen for Spendly.
/// Displays animated brand logo, glowing aura, and encrypted vault badge.
class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashScreen({
    super.key,
    required this.onFinish,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _taglineFadeAnimation;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Smooth physics-based scale entrance for the logo
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Logo fade-in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    // Staggered tagline and brand text fade-in
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
      ),
    );

    // Slim progress capsule filler
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        widget.onFinish();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Ambient Glow Background Orbs
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.glacierMint.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Central Brand Hero
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppStyles.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Animated Logo with Ambient Cyan Glow
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 108,
                          height: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.glacier.withValues(alpha: 0.35),
                                blurRadius: 36,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppStyles.lg),

                    // App Title
                    FadeTransition(
                      opacity: _taglineFadeAnimation,
                      child: Column(
                        children: [
                          const Text(
                            'Spendly',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                              color: AppColors.darkTextPrimary,
                            ),
                          ),
                          const SizedBox(height: AppStyles.xs),
                          Text(
                            'Track your spending. Understand your money.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkTextSecondary.withValues(alpha: 0.8),
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppStyles.xl),

                    // Slim Gradient Progress Track
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      child: null,
                      builder: (context, _) {
                        return Container(
                          width: 140,
                          height: 3.5,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: _progressAnimation.value.clamp(0.02, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.glacierMintGradient,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.glacierMint.withValues(alpha: 0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    // Security Badge Footer
                    FadeTransition(
                      opacity: _taglineFadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppStyles.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 13,
                              color: AppColors.darkTextSecondary.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'END-TO-END ENCRYPTED VAULT',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.4,
                                color: AppColors.darkTextSecondary.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
