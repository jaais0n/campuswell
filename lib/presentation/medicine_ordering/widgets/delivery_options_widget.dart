import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryOptionsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onDeliveryOptionSelected;
  final Map<String, dynamic>? selectedOption;

  const DeliveryOptionsWidget({
    super.key,
    required this.onDeliveryOptionSelected,
    this.selectedOption,
  });

  @override
  State<DeliveryOptionsWidget> createState() => _DeliveryOptionsWidgetState();
}

class _DeliveryOptionsWidgetState extends State<DeliveryOptionsWidget> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> deliveryOptions = [
    {
      "id": "campus_pickup",
      "title": "Campus Pickup",
      "subtitle": "Health Center Pharmacy",
      "description": "Pick up from campus health center during business hours",
      "cost": 0.0,
      "estimatedTime": "2-4 hours",
      "icon": "local_hospital",
      "address": "Student Health Center, Main Campus",
      "hours": "Mon-Fri: 8AM-6PM, Sat: 9AM-2PM",
      "benefits": [
        "No delivery fee",
        "Pharmacist consultation",
        "Insurance processing"
      ],
    },
    {
      "id": "dorm_delivery",
      "title": "Dorm Delivery",
      "subtitle": "Direct to your room",
      "description": "Secure delivery to your dormitory with ID verification",
      "cost": 5.99,
      "estimatedTime": "4-6 hours",
      "icon": "home",
      "address": "Your registered dorm address",
      "hours": "Daily: 9AM-8PM",
      "benefits": [
        "Contactless delivery",
        "SMS notifications",
        "Secure handoff"
      ],
    },
    {
      "id": "express_delivery",
      "title": "Express Delivery",
      "subtitle": "Priority service",
      "description": "Fast delivery anywhere on campus within 2 hours",
      "cost": 12.99,
      "estimatedTime": "1-2 hours",
      "icon": "flash_on",
      "address": "Any campus location",
      "hours": "Daily: 8AM-10PM",
      "benefits": ["Fastest option", "Real-time tracking", "Priority handling"],
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.selectedOption != null) {
      _selectedIndex = deliveryOptions.indexWhere(
        (option) => option["id"] == widget.selectedOption!["id"],
      );
      if (_selectedIndex == -1) _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Delivery Options',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Segmented control style selector
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: deliveryOptions.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = _selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _selectOption(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        CustomIconWidget(
                          iconName: option["icon"] as String,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option["title"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 3.h),

        // Selected option details
        _buildSelectedOptionDetails(
          deliveryOptions[_selectedIndex],
          colorScheme,
          theme,
        ),
      ],
    );
  }

  Widget _buildSelectedOptionDetails(
    Map<String, dynamic> option,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final cost = option["cost"] as double;
    final benefits = (option["benefits"] as List).cast<String>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: option["icon"] as String,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option["title"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      option["subtitle"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Cost and time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    cost == 0 ? 'FREE' : '\$${cost.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cost == 0
                          ? AppTheme.successLight
                          : colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    option["estimatedTime"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            option["description"] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),

          SizedBox(height: 2.h),

          // Address and hours
          _buildInfoRow(
            icon: 'location_on',
            label: 'Address',
            value: option["address"] as String,
            colorScheme: colorScheme,
            theme: theme,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: 'schedule',
            label: 'Hours',
            value: option["hours"] as String,
            colorScheme: colorScheme,
            theme: theme,
          ),

          SizedBox(height: 2.h),

          // Benefits
          Text(
            'Benefits',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...benefits.map((benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.successLight,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        benefit,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              )),

          if (option["id"] == "express_delivery") ...[
            SizedBox(height: 2.h),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.warningLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Express delivery requires prescription verification and may have limited availability during peak hours.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: icon,
          color: colorScheme.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  void _selectOption(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onDeliveryOptionSelected(deliveryOptions[index]);
  }
}
