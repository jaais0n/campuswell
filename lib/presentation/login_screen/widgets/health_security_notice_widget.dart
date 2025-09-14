import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HealthSecurityNoticeWidget extends StatelessWidget {
  const HealthSecurityNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security Icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'security',
              color: colorScheme.primary,
              size: 5.w,
            ),
          ),

          SizedBox(width: 3.w),

          // Security Notice Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Health Data is Protected',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  'CampusWell uses end-to-end encryption and follows HIPAA compliance standards to protect your personal health information.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 1.5.h),

                // Security Features
                Row(
                  children: [
                    _buildSecurityFeature(
                      context,
                      'encrypted',
                      'Encrypted',
                    ),
                    SizedBox(width: 4.w),
                    _buildSecurityFeature(
                      context,
                      'verified_user',
                      'HIPAA Compliant',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityFeature(
    BuildContext context,
    String iconName,
    String label,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.primary,
          size: 3.5.w,
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.primary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
