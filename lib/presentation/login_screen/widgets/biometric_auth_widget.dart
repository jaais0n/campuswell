import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback? onBiometricAuth;
  final bool isEnabled;

  const BiometricAuthWidget({
    super.key,
    this.onBiometricAuth,
    this.isEnabled = true,
  });

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleBiometricAuth() async {
    if (!widget.isEnabled || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    HapticFeedback.mediumImpact();

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        HapticFeedback.heavyImpact();
        widget.onBiometricAuth?.call();
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Biometric authentication failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: colorScheme.outline.withValues(alpha: 0.5),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'or continue with',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: colorScheme.outline.withValues(alpha: 0.5),
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Biometric Authentication Button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: _handleBiometricAuth,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(4.w),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _isAuthenticating
                      ? Center(
                          child: SizedBox(
                            width: 6.w,
                            height: 6.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: CustomIconWidget(
                            iconName: 'fingerprint',
                            color: colorScheme.primary,
                            size: 8.w,
                          ),
                        ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 2.h),

        // Biometric Auth Label
        Text(
          _isAuthenticating ? 'Authenticating...' : 'Use Biometric',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
