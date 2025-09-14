import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SafeStatusWidget extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onSafeConfirmed;

  const SafeStatusWidget({
    super.key,
    this.isVisible = false,
    this.onSafeConfirmed,
  });

  @override
  State<SafeStatusWidget> createState() => _SafeStatusWidgetState();
}

class _SafeStatusWidgetState extends State<SafeStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(SafeStatusWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  void _confirmSafe() {
    setState(() {
      _isConfirmed = true;
    });

    HapticFeedback.heavyImpact();
    widget.onSafeConfirmed?.call();

    // Auto-hide after confirmation
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: _isConfirmed
                    ? colorScheme.tertiary.withValues(alpha: 0.1)
                    : colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      _isConfirmed ? colorScheme.tertiary : colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // Status Icon
                  Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                      color: _isConfirmed
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _isConfirmed ? 'check_circle' : 'help',
                        color: colorScheme.onPrimary,
                        size: 32,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Status Text
                  Text(
                    _isConfirmed ? 'Thank You!' : 'Are You Safe?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: _isConfirmed
                          ? colorScheme.tertiary
                          : colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    _isConfirmed
                        ? 'Emergency contacts have been notified that you are safe.'
                        : 'Emergency services have been contacted. Please confirm your safety status.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  if (!_isConfirmed) ...[
                    SizedBox(height: 4.h),

                    // Safe Button
                    SizedBox(
                      width: 70.w,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed: _confirmSafe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.tertiary,
                          foregroundColor: colorScheme.onTertiary,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: colorScheme.onTertiary,
                              size: 24,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'I\'m Safe',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
