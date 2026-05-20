import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Full-bleed image card with scrim overlay and positioned overlay widgets.
///
/// Used for cinematic venue cards in the explore feed.
class AppHeroImageCard extends StatelessWidget {
  const AppHeroImageCard({
    super.key,
    required this.imageUrl,
    this.height = 220,
    this.borderRadius,
    this.topLeft,
    this.topRight,
    this.bottomContent,
    this.onTap,
    this.aspectRatio,
  });

  final String imageUrl;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? topLeft;
  final Widget? topRight;
  final Widget? bottomContent;
  final VoidCallback? onTap;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.borderRadiusMd;
    Widget card = ClipRRect(
      borderRadius: effectiveRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF141F38),
              child: const Icon(Icons.image_not_supported_outlined,
                  color: Color(0xFF6D758C), size: 40),
            ),
          ),
          // Scrim overlay
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppGradients.scrimOverlay),
          ),
          // Overlay widgets
          if (topLeft != null)
            Positioned(top: 12, left: 12, child: topLeft!),
          if (topRight != null)
            Positioned(top: 12, right: 12, child: topRight!),
          if (bottomContent != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: bottomContent!,
            ),
          // Tap handler
          if (onTap != null)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(onTap: onTap),
              ),
            ),
        ],
      ),
    );

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: card);
    }
    return SizedBox(height: height, child: card);
  }
}
