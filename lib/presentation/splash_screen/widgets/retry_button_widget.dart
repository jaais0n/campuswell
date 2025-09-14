import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class RetryButtonWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const RetryButtonWidget({
    super.key,
    required this.onRetry,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.errorContainer
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 8.w,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 5.w,
          ),
          label: Text(
            'Try Again',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}