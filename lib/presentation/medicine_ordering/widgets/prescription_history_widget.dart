import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrescriptionHistoryWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onReorder;

  const PrescriptionHistoryWidget({
    super.key,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> prescriptionHistory = [
      {
        "id": "RX001",
        "medicationName": "Amoxicillin",
        "dosage": "500mg",
        "quantity": 30,
        "refillsRemaining": 2,
        "expirationDate": DateTime(2024, 12, 15),
        "doctorName": "Dr. Sarah Johnson",
        "lastFilled": DateTime(2024, 9, 1),
        "instructions": "Take twice daily with food",
        "status": "active",
        "image":
            "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=400&h=300&fit=crop",
      },
      {
        "id": "RX002",
        "medicationName": "Ibuprofen",
        "dosage": "200mg",
        "quantity": 60,
        "refillsRemaining": 0,
        "expirationDate": DateTime(2024, 10, 30),
        "doctorName": "Dr. Michael Chen",
        "lastFilled": DateTime(2024, 8, 15),
        "instructions": "Take as needed for pain",
        "status": "expired",
        "image":
            "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop",
      },
      {
        "id": "RX003",
        "medicationName": "Vitamin D3",
        "dosage": "1000 IU",
        "quantity": 90,
        "refillsRemaining": 3,
        "expirationDate": DateTime(2025, 3, 20),
        "doctorName": "Dr. Emily Rodriguez",
        "lastFilled": DateTime(2024, 9, 10),
        "instructions": "Take once daily with meal",
        "status": "active",
        "image":
            "https://images.unsplash.com/photo-1550572017-edd951aa8f72?w=400&h=300&fit=crop",
      },
      {
        "id": "RX004",
        "medicationName": "Lisinopril",
        "dosage": "10mg",
        "quantity": 30,
        "refillsRemaining": 1,
        "expirationDate": DateTime(2024, 11, 25),
        "doctorName": "Dr. James Wilson",
        "lastFilled": DateTime(2024, 8, 25),
        "instructions": "Take once daily in morning",
        "status": "low_refills",
        "image":
            "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=400&h=300&fit=crop",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prescription History',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Navigate to full history
                },
                icon: CustomIconWidget(
                  iconName: 'history',
                  color: colorScheme.primary,
                  size: 18,
                ),
                label: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 32.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            scrollDirection: Axis.horizontal,
            itemCount: prescriptionHistory.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final prescription = prescriptionHistory[index];
              return _buildPrescriptionCard(
                context,
                prescription,
                colorScheme,
                theme,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard(
    BuildContext context,
    Map<String, dynamic> prescription,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final status = prescription["status"] as String;
    final expirationDate = prescription["expirationDate"] as DateTime;
    final refillsRemaining = prescription["refillsRemaining"] as int;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'active':
        statusColor = AppTheme.successLight;
        statusText = 'Active';
        statusIcon = Icons.check_circle;
        break;
      case 'expired':
        statusColor = AppTheme.errorLight;
        statusText = 'Expired';
        statusIcon = Icons.error;
        break;
      case 'low_refills':
        statusColor = AppTheme.warningLight;
        statusText = 'Low Refills';
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = colorScheme.onSurfaceVariant;
        statusText = 'Unknown';
        statusIcon = Icons.help;
    }

    return Container(
      width: 70.w,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with medication image and status
          Container(
            height: 12.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: Stack(
              children: [
                // Medication image
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CustomImageWidget(
                      imageUrl: prescription["image"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Status badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Medication details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medication name and dosage
                  Text(
                    prescription["medicationName"] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${prescription["dosage"]} • ${prescription["quantity"]} tablets',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Doctor and expiration info
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'person',
                        color: colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          prescription["doctorName"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expires ${_formatDate(expirationDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Refills and reorder section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Refills Left',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            refillsRemaining.toString(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: refillsRemaining > 0
                                  ? colorScheme.primary
                                  : AppTheme.errorLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Reorder button
                      status == 'active' || status == 'low_refills'
                          ? _buildReorderButton(
                              context,
                              prescription,
                              colorScheme,
                              theme,
                            )
                          : OutlinedButton(
                              onPressed: null,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: Text(
                                'Expired',
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReorderButton(
    BuildContext context,
    Map<String, dynamic> prescription,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final refillsRemaining = prescription["refillsRemaining"] as int;

    return ElevatedButton(
      onPressed: refillsRemaining > 0 ? () => onReorder(prescription) : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        minimumSize: Size(20.w, 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'refresh',
            color: refillsRemaining > 0
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'Reorder',
            style: theme.textTheme.labelMedium?.copyWith(
              color: refillsRemaining > 0
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'Expired';
    } else if (difference < 30) {
      return '${difference}d left';
    } else {
      final months = (difference / 30).floor();
      return '${months}mo left';
    }
  }
}
