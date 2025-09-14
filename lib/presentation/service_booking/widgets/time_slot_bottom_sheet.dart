import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TimeSlotBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final String serviceType;
  final Function(Map<String, dynamic>) onSlotSelected;

  const TimeSlotBottomSheet({
    super.key,
    required this.selectedDate,
    required this.serviceType,
    required this.onSlotSelected,
  });

  @override
  State<TimeSlotBottomSheet> createState() => _TimeSlotBottomSheetState();
}

class _TimeSlotBottomSheetState extends State<TimeSlotBottomSheet> {
  String? selectedSlotId;

  final List<Map<String, dynamic>> _timeSlots = [
    {
      'id': 'slot_1',
      'time': '09:00 AM',
      'provider': 'Dr. Sarah Johnson',
      'specialization': 'General Medicine',
      'isAvailable': true,
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_2',
      'time': '09:30 AM',
      'provider': 'Dr. Michael Chen',
      'specialization': 'Internal Medicine',
      'isAvailable': true,
      'rating': 4.9,
      'image':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_3',
      'time': '10:00 AM',
      'provider': 'Dr. Emily Rodriguez',
      'specialization': 'Family Medicine',
      'isAvailable': false,
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1594824475317-d7b7b8b8b8b8?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_4',
      'time': '10:30 AM',
      'provider': 'Dr. James Wilson',
      'specialization': 'General Practice',
      'isAvailable': true,
      'rating': 4.6,
      'image':
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_5',
      'time': '11:00 AM',
      'provider': 'Dr. Lisa Thompson',
      'specialization': 'Preventive Medicine',
      'isAvailable': true,
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1594824475317-d7b7b8b8b8b8?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_6',
      'time': '02:00 PM',
      'provider': 'Dr. Robert Davis',
      'specialization': 'General Medicine',
      'isAvailable': true,
      'rating': 4.5,
      'image':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_7',
      'time': '02:30 PM',
      'provider': 'Dr. Amanda White',
      'specialization': 'Family Medicine',
      'isAvailable': true,
      'rating': 4.9,
      'image':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face',
    },
    {
      'id': 'slot_8',
      'time': '03:00 PM',
      'provider': 'Dr. Kevin Brown',
      'specialization': 'Internal Medicine',
      'isAvailable': false,
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face',
    },
  ];

  List<Map<String, dynamic>> _getCounselingSlots() {
    return [
      {
        'id': 'counseling_1',
        'time': '09:00 AM',
        'provider': 'Dr. Maria Garcia',
        'specialization': 'Clinical Psychology',
        'isAvailable': true,
        'rating': 4.9,
        'image':
            'https://images.unsplash.com/photo-1594824475317-d7b7b8b8b8b8?w=400&h=400&fit=crop&crop=face',
      },
      {
        'id': 'counseling_2',
        'time': '10:00 AM',
        'provider': 'Dr. David Kim',
        'specialization': 'Counseling Psychology',
        'isAvailable': true,
        'rating': 4.8,
        'image':
            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face',
      },
      {
        'id': 'counseling_3',
        'time': '11:00 AM',
        'provider': 'Dr. Jennifer Lee',
        'specialization': 'Mental Health Counseling',
        'isAvailable': false,
        'rating': 4.7,
        'image':
            'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face',
      },
      {
        'id': 'counseling_4',
        'time': '02:00 PM',
        'provider': 'Dr. Thomas Anderson',
        'specialization': 'Behavioral Therapy',
        'isAvailable': true,
        'rating': 4.6,
        'image':
            'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face',
      },
    ];
  }

  List<Map<String, dynamic>> _getDisabilitySlots() {
    return [
      {
        'id': 'disability_1',
        'time': '09:00 AM',
        'provider': 'Alex Martinez',
        'specialization': 'Mobility Assistance',
        'isAvailable': true,
        'rating': 4.8,
        'image':
            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face',
      },
      {
        'id': 'disability_2',
        'time': '10:00 AM',
        'provider': 'Sarah Johnson',
        'specialization': 'Accessibility Support',
        'isAvailable': true,
        'rating': 4.9,
        'image':
            'https://images.unsplash.com/photo-1594824475317-d7b7b8b8b8b8?w=400&h=400&fit=crop&crop=face',
      },
      {
        'id': 'disability_3',
        'time': '11:00 AM',
        'provider': 'Mike Wilson',
        'specialization': 'Wheelchair Service',
        'isAvailable': true,
        'rating': 4.7,
        'image':
            'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face',
      },
    ];
  }

  List<Map<String, dynamic>> _getAvailableSlots() {
    switch (widget.serviceType) {
      case 'counseling':
        return _getCounselingSlots();
      case 'disability':
        return _getDisabilitySlots();
      default:
        return _timeSlots;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableSlots = _getAvailableSlots();

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Time Slots',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${_formatDate(widget.selectedDate)} • ${availableSlots.where((slot) => slot['isAvailable'] == true).length} slots available',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Time slots list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: availableSlots.length,
              itemBuilder: (context, index) {
                final slot = availableSlots[index];
                return _buildTimeSlotCard(slot);
              },
            ),
          ),

          // Book button
          if (selectedSlotId != null)
            Container(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final selectedSlot = availableSlots.firstWhere(
                      (slot) => slot['id'] == selectedSlotId,
                    );
                    widget.onSlotSelected(selectedSlot);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(Map<String, dynamic> slot) {
    final isSelected = selectedSlotId == slot['id'];
    final isAvailable = slot['isAvailable'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: isAvailable
            ? () {
                setState(() {
                  selectedSlotId = slot['id'];
                });
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : isAvailable
                    ? AppTheme.lightTheme.colorScheme.surface
                    : AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : isAvailable
                      ? AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Provider image
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
                    imageUrl: slot['image'],
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Provider details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            slot['provider'],
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isAvailable
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        if (!isAvailable)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Booked',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      slot['specialization'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isAvailable
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'access_time',
                          color: isAvailable
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          slot['time'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isAvailable
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${slot['rating']}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isAvailable
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selection indicator
              if (isSelected && isAvailable)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
