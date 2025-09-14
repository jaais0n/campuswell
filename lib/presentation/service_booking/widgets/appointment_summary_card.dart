import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppointmentSummaryCard extends StatelessWidget {
  final String serviceType;
  final DateTime selectedDate;
  final Map<String, dynamic>? selectedSlot;
  final String appointmentType;
  final String requirements;

  const AppointmentSummaryCard({
    super.key,
    required this.serviceType,
    required this.selectedDate,
    this.selectedSlot,
    required this.appointmentType,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedSlot == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'event_available',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Appointment Summary',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Provider info
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: selectedSlot!['image'],
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedSlot!['provider'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      selectedSlot!['specialization'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${selectedSlot!['rating']} rating',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Appointment details
          _buildDetailRow(
            icon: 'calendar_today',
            label: 'Date',
            value: _formatDate(selectedDate),
          ),
          SizedBox(height: 2.h),
          _buildDetailRow(
            icon: 'access_time',
            label: 'Time',
            value: selectedSlot!['time'],
          ),
          SizedBox(height: 2.h),
          _buildDetailRow(
            icon: 'category',
            label: 'Service',
            value: _getServiceTitle(serviceType),
          ),
          SizedBox(height: 2.h),
          _buildDetailRow(
            icon: 'assignment',
            label: 'Type',
            value: _getAppointmentTypeTitle(appointmentType),
          ),

          if (requirements.isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildDetailRow(
              icon: 'note',
              label: 'Requirements',
              value: requirements,
              isMultiline: true,
            ),
          ],

          SizedBox(height: 3.h),

          // Important notes
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Important Notes',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Please arrive 15 minutes early\n• Bring your student ID and insurance card\n• Cancellations must be made 24 hours in advance',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String icon,
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Row(
      crossAxisAlignment:
          isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 18,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getServiceTitle(String serviceType) {
    switch (serviceType) {
      case 'doctor':
        return 'Doctor Appointment';
      case 'counseling':
        return 'Counseling Session';
      case 'disability':
        return 'Disability Assistance';
      default:
        return 'Medical Service';
    }
  }

  String _getAppointmentTypeTitle(String appointmentType) {
    switch (appointmentType) {
      case 'initial':
        return 'Initial Consultation';
      case 'followup':
        return 'Follow-up Visit';
      case 'emergency':
        return 'Emergency Appointment';
      default:
        return 'Standard Appointment';
    }
  }
}
