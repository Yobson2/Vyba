import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/buttons/app_gradient_button.dart';

/// Animated success overlay with pulsing checkmark.
class AppSuccessModal extends StatefulWidget {
  const AppSuccessModal({
    super.key,
    required this.title,
    this.subtitle,
    this.primaryButtonLabel = 'Done',
    this.onPrimaryPressed,
    this.secondaryButtonLabel,
    this.onSecondaryPressed,
    this.content,
  });

  final String title;
  final String? subtitle;
  final String primaryButtonLabel;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryButtonLabel;
  final VoidCallback? onSecondaryPressed;
  final Widget? content;

  /// Show this modal as a dialog.
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? subtitle,
    String primaryButtonLabel = 'Done',
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryPressed,
    Widget? content,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppSuccessModal(
        title: title,
        subtitle: subtitle,
        primaryButtonLabel: primaryButtonLabel,
        onPrimaryPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
        secondaryButtonLabel: secondaryButtonLabel,
        onSecondaryPressed: onSecondaryPressed,
        content: content,
      ),
    );
  }

  @override
  State<AppSuccessModal> createState() => _AppSuccessModalState();
}

class _AppSuccessModalState extends State<AppSuccessModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
      child: Padding(
        padding: AppSpacing.paddingXl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryContainer,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.secondary,
                  size: 40,
                ),
              ),
            ),
            AppSpacing.verticalLg,
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (widget.subtitle != null) ...[
              AppSpacing.verticalSm,
              Text(
                widget.subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (widget.content != null) ...[
              AppSpacing.verticalLg,
              widget.content!,
            ],
            AppSpacing.verticalXl,
            AppGradientButton(
              onPressed: widget.onPrimaryPressed,
              label: widget.primaryButtonLabel,
            ),
            if (widget.secondaryButtonLabel != null) ...[
              AppSpacing.verticalSm,
              TextButton(
                onPressed: widget.onSecondaryPressed,
                child: Text(widget.secondaryButtonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
