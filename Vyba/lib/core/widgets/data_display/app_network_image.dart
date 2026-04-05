import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/widgets/loading/app_shimmer.dart';

/// Cached network image with shimmer placeholder and error fallback.
class AppNetworkImage extends StatelessWidget {
  /// Creates an [AppNetworkImage].
  const AppNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  /// The image URL to load.
  final String imageUrl;

  /// Image width.
  final double? width;

  /// Image height.
  final double? height;

  /// How the image fits its box.
  final BoxFit fit;

  /// Border radius. Defaults to [AppRadius.borderRadiusMd].
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? AppRadius.borderRadiusMd,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => AppShimmer(
          width: width ?? double.infinity,
          height: height ?? 200,
        ),
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
