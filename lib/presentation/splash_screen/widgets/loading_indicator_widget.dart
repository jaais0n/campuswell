import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingIndicatorWidget extends StatefulWidget {
  final double progress;
  final String loadingText;

  const LoadingIndicatorWidget({
    super.key,
    required this.progress,
    required this.loadingText,
  });

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotAnimationController;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();
    _dotAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _dotAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotAnimationController,
      curve: Curves.easeInOut,
    ));

    _dotAnimationController.repeat();
  }

  @override
  void dispose() {
    _dotAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        Container(
          width: 60.w,
          height: 0.8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppTheme.lightTheme.colorScheme.surface,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.progress,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        // Loading text with animated dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.loadingText,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            AnimatedBuilder(
              animation: _dotAnimation,
              builder: (context, child) {
                return Row(
                  children: List.generate(3, (index) {
                    final delay = index * 0.3;
                    final opacity =
                        (_dotAnimation.value - delay).clamp(0.0, 1.0);
                    return Opacity(
                      opacity: opacity > 0.5 ? 1.0 : 0.3,
                      child: Text(
                        '.',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}