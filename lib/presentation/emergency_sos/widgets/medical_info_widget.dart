import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MedicalInfoWidget extends StatelessWidget {
  const MedicalInfoWidget({super.key});

  final Map<String, dynamic> _medicalInfo = const {
    "bloodType": "O+",
    "allergies": ["Penicillin", "Shellfish"],
    "conditions": ["Asthma"],
    "medications": ["Albuterol Inhaler", "Daily Vitamin D"],
    "emergencyContact": {
      "name": "Sarah Johnson",
      "relationship": "Mother",
      "phone": "(555) 456-7890"
    },
    "lastUpdated": "2025-09-10"
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'medical_information',
                color: colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Medical Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Blood Type
          _buildInfoRow(
            context,
            'Blood Type',
            _medicalInfo["bloodType"] as String,
            'bloodtype',
            colorScheme.error,
          ),

          SizedBox(height: 2.h),

          // Allergies
          _buildInfoSection(
            context,
            'Allergies',
            (_medicalInfo["allergies"] as List).join(', '),
            'warning',
            colorScheme.error,
          ),

          SizedBox(height: 2.h),

          // Medical Conditions
          _buildInfoSection(
            context,
            'Medical Conditions',
            (_medicalInfo["conditions"] as List).join(', '),
            'local_hospital',
            colorScheme.primary,
          ),

          SizedBox(height: 2.h),

          // Current Medications
          _buildInfoSection(
            context,
            'Current Medications',
            (_medicalInfo["medications"] as List).join(', '),
            'medication',
            colorScheme.tertiary,
          ),

          SizedBox(height: 3.h),

          // Emergency Contact
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'contact_emergency',
                      color: colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Emergency Contact',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '${(_medicalInfo["emergencyContact"] as Map<String, dynamic>)["name"]} (${(_medicalInfo["emergencyContact"] as Map<String, dynamic>)["relationship"]})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  (_medicalInfo["emergencyContact"]
                      as Map<String, dynamic>)["phone"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Last Updated
          Text(
            'Last updated: ${_medicalInfo["lastUpdated"]}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
