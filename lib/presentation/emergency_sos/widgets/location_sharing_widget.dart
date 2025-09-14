import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LocationSharingWidget extends StatefulWidget {
  final bool isLocationShared;
  final ValueChanged<bool>? onLocationToggle;

  const LocationSharingWidget({
    super.key,
    this.isLocationShared = false,
    this.onLocationToggle,
  });

  @override
  State<LocationSharingWidget> createState() => _LocationSharingWidgetState();
}

class _LocationSharingWidgetState extends State<LocationSharingWidget> {
  String _currentLocation = 'Fetching location...';
  String _accuracy = 'Unknown';
  bool _isLocationEnabled = false;

  @override
  void initState() {
    super.initState();
    _isLocationEnabled = widget.isLocationShared;
    if (_isLocationEnabled) {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() {
    // Mock location data for demonstration
    setState(() {
      _currentLocation = 'Campus Health Center, University Ave';
      _accuracy = 'Accurate to 5 meters';
    });
  }

  void _toggleLocationSharing(bool value) {
    setState(() {
      _isLocationEnabled = value;
    });

    if (value) {
      _getCurrentLocation();
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        _currentLocation = 'Location sharing disabled';
        _accuracy = 'Unknown';
      });
    }

    widget.onLocationToggle?.call(value);
  }

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
          // Location Header with Toggle
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: _isLocationEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Location Sharing',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: _isLocationEnabled,
                onChanged: _toggleLocationSharing,
                activeColor: colorScheme.primary,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Current Location Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _isLocationEnabled
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'my_location',
                      color: _isLocationEnabled
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Current Location',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _currentLocation,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  _accuracy,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          if (_isLocationEnabled) ...[
            SizedBox(height: 3.h),

            // Location Sharing Status
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.tertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.tertiary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: colorScheme.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Location shared with emergency services',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
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
}
