import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HealthStatusCard extends StatelessWidget {
  final String userName;
  final Map<String, dynamic> healthData;

  const HealthStatusCard({
    super.key,
    required this.userName,
    required this.healthData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.successLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.health_and_safety_outlined,
                      color: AppTheme.successLight,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Health Status',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          healthData['status'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Active',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.successLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: _buildHealthMetric(
                      'Heart Rate',
                      '${healthData['heartRate']} bpm',
                      Icons.favorite_outline,
                      AppTheme.errorLight,
                      context,
                    ),
                  ),
                  Expanded(
                    child: _buildHealthMetric(
                      'Blood Pressure',
                      healthData['bloodPressure'] as String,
                      Icons.monitor_heart_outlined,
                      AppTheme.primaryLight,
                      context,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: _buildHealthMetric(
                      'BMI',
                      '${healthData['bmi']}',
                      Icons.scale_outlined,
                      AppTheme.warningLight,
                      context,
                    ),
                  ),
                  Expanded(
                    child: _buildHealthMetric(
                      'Last Checkup',
                      _formatDate(healthData['lastCheckup'] as String),
                      Icons.calendar_today_outlined,
                      colorScheme.onSurfaceVariant,
                      context,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/service-booking');
                  },
                  icon: Icon(Icons.calendar_month_outlined, size: 4.w),
                  label: const Text('Book Health Checkup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthMetric(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 6.w),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date).inDays;

      if (difference == 0) return 'Today';
      if (difference == 1) return 'Yesterday';
      if (difference < 7) return '$difference days ago';
      if (difference < 30) return '${(difference / 7).floor()} weeks ago';

      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
