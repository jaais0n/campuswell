import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> quickActions = [
      {
        'title': 'Emergency',
        'icon': Icons.emergency_outlined,
        'color': AppTheme.errorLight,
        'route': '/emergency-sos',
      },
      {
        'title': 'Appointment',
        'icon': Icons.calendar_month_outlined,
        'color': AppTheme.primaryLight,
        'route': '/service-booking',
      },
      {
        'title': 'Medicine',
        'icon': Icons.medication_outlined,
        'color': Color(0xFF7B1FA2),
        'route': '/medicine-ordering',
      },
      {
        'title': 'Chat',
        'icon': Icons.chat_outlined,
        'color': Color(0xFF00796B),
        'route': '/chat',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text(
            'Quick Actions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            itemCount: quickActions.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final action = quickActions[index];
              return _buildQuickActionCard(context, action);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    Map<String, dynamic> action,
  ) {
    final theme = Theme.of(context);
    final actionColor = action['color'] as Color;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, action['route'] as String);
      },
      child: Container(
        width: 20.w,
        decoration: BoxDecoration(
          color: actionColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: actionColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: actionColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                action['icon'] as IconData,
                color: Colors.white,
                size: 4.w,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              action['title'] as String,
              style: theme.textTheme.labelMedium?.copyWith(
                color: actionColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
