import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_effects.dart';
import 'package:flutter_templates/core/theme/app_motion.dart';

/// PageView-based hero image carousel with dot indicators and auto-advance.
class AppImageCarousel extends StatefulWidget {
  const AppImageCarousel({
    super.key,
    required this.imageUrls,
    this.height = 300,
    this.onPageChanged,
    this.overlayBuilder,
    this.autoAdvance = true,
    this.autoAdvanceInterval = const Duration(seconds: 5),
  });

  final List<String> imageUrls;
  final double height;
  final ValueChanged<int>? onPageChanged;
  final Widget Function(int index)? overlayBuilder;
  final bool autoAdvance;
  final Duration autoAdvanceInterval;

  @override
  State<AppImageCarousel> createState() => _AppImageCarouselState();
}

class _AppImageCarouselState extends State<AppImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    if (!widget.autoAdvance || widget.imageUrls.length <= 1) return;
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer.periodic(widget.autoAdvanceInterval, (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.imageUrls.length;
      _pageController.animateToPage(
        nextPage,
        duration: AppMotion.normal,
        curve: AppMotion.defaultCurve,
      );
    });
  }

  void _pauseAutoAdvance() => _autoAdvanceTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          GestureDetector(
            onPanDown: (_) => _pauseAutoAdvance(),
            onPanEnd: (_) => _startAutoAdvance(),
            onPanCancel: _startAutoAdvance,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.imageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: AppColors.surfaceContainerHigh,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.outline,
                          size: AppIconSize.xxl,
                        ),
                      ),
                    ),
                    if (widget.overlayBuilder != null)
                      widget.overlayBuilder!(index),
                  ],
                );
              },
            ),
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => AnimatedContainer(
                    duration: AppMotion.fast,
                    curve: AppMotion.defaultCurve,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _currentPage ? 24 : 8,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: index == _currentPage
                          ? AppColors.primary
                          : AppColors.onSurface
                              .withValues(alpha: AppOpacity.moderate),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
