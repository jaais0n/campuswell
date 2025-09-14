import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> activities = [
      {
        'title': 'Annual Health Checkup',
        'subtitle': 'Dr. Sarah Wilson - Completed',
        'time': '2 days ago',
        'icon': Icons.medical_services_outlined,
        'color': AppTheme.primaryLight,
      },
      {
        'title': 'Prescription Refill',
        'subtitle': 'Vitamin D supplement - Delivered',
        'time': '1 week ago',
        'icon': Icons.medication_outlined,
        'color': Color(0xFF7B1FA2),
      },
      {
        'title': 'Mental Wellness Session',
        'subtitle': 'Dr. Michael Chen - Completed',
        'time': '2 weeks ago',
        'icon': Icons.psychology_outlined,
        'color': Color(0xFF00796B),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Row(
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to full activity history
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          child: Card(
            child: Column(
              children:
                  activities
                      .asMap()
                      .entries
                      .map(
                        (entry) => _buildActivityItem(
                          context,
                          entry.value,
                          entry.key == activities.length - 1,
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    bool isLast,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activityColor = activity['color'] as Color;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(
                  bottom: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: activityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activityColor,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  activity['subtitle'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
