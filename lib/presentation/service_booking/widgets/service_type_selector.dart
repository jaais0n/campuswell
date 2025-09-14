import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceTypeSelector extends StatelessWidget {
  final String selectedService;
  final Function(String) onServiceChanged;

  const ServiceTypeSelector({
    super.key,
    required this.selectedService,
    required this.onServiceChanged,
  });

  final List<Map<String, dynamic>> _serviceTypes = const [
    {
      'id': 'doctor',
      'title': 'Doctor Appointments',
      'description': 'Book appointments with campus medical professionals',
      'icon': 'medical_services',
      'color': Color(0xFF2B7A78),
    },
    {
      'id': 'counseling',
      'title': 'Counseling Sessions',
      'description': 'Schedule mental health and wellness consultations',
      'icon': 'psychology',
      'color': Color(0xFF52B788),
    },
    {
      'id': 'disability',
      'title': 'Disability Assistance',
      'description': 'Request wheelchair and accessibility support services',
      'icon': 'accessible',
      'color': Color(0xFF3AAFA9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Service Type',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          ...(_serviceTypes
              .map((service) => _buildServiceCard(service))
              .toList()),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final isSelected = selectedService == service['id'];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: GestureDetector(
        onTap: () => onServiceChanged(service['id']),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: isSelected
                ? (service['color'] as Color).withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? service['color'] as Color
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (service['color'] as Color).withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? service['color'] as Color
                      : (service['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: service['icon'],
                  color: isSelected ? Colors.white : service['color'] as Color,
                  size: 24,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? service['color'] as Color
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      service['description'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: service['color'] as Color,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
