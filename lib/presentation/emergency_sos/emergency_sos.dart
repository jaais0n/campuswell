import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/emergency_contacts_widget.dart';
import './widgets/location_sharing_widget.dart';
import './widgets/medical_info_widget.dart';
import './widgets/safe_status_widget.dart';

class EmergencySos extends StatefulWidget {
  const EmergencySos({super.key});

  @override
  State<EmergencySos> createState() => _EmergencySosState();
}

class _EmergencySosState extends State<EmergencySos> {
  bool _isEmergencyActive = true;
  bool _isLocationShared = true;
  bool _showSafeStatus = false;
  bool _isCallConnected = false;

  @override
  void initState() {
    super.initState();
    // Prevent accidental dismissal
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Start location sharing automatically
    _startLocationSharing();
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startLocationSharing() {
    setState(() {
      _isLocationShared = true;
    });
  }

  void _onTimerComplete() {
    setState(() {
      _isEmergencyActive = false;
      _isCallConnected = true;
      _showSafeStatus = true;
    });

    HapticFeedback.heavyImpact();

    // Show call connected notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Emergency call connected to Campus Security'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _onEmergencyCancel() {
    setState(() {
      _isEmergencyActive = false;
    });

    // Show cancellation confirmation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Cancelled'),
        content: const Text(
            'Your emergency call has been cancelled. You can safely return to the app.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/health-dashboard');
            },
            child: const Text('Return to Dashboard'),
          ),
        ],
      ),
    );
  }

  void _onLocationToggle(bool isEnabled) {
    setState(() {
      _isLocationShared = isEnabled;
    });
  }

  void _onContactCalled() {
    setState(() {
      _isCallConnected = true;
      _showSafeStatus = true;
    });
  }

  void _onSafeConfirmed() {
    // Send all-clear notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Safety confirmation sent to emergency contacts'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation during active emergency
        if (_isEmergencyActive) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: colorScheme.error.withValues(alpha: 0.05),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Emergency Header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'emergency',
                          color: colorScheme.onError,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency SOS',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Campus emergency services activated',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isEmergencyActive)
                        IconButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/health-dashboard'),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 6.h),

                // Countdown Timer
                if (_isEmergencyActive)
                  CountdownTimerWidget(
                    initialSeconds: 30,
                    onTimerComplete: _onTimerComplete,
                    onCancel: _onEmergencyCancel,
                  ),

                SizedBox(height: 6.h),

                // Location Sharing
                LocationSharingWidget(
                  isLocationShared: _isLocationShared,
                  onLocationToggle: _onLocationToggle,
                ),

                SizedBox(height: 4.h),

                // Safe Status Widget
                SafeStatusWidget(
                  isVisible: _showSafeStatus,
                  onSafeConfirmed: _onSafeConfirmed,
                ),

                SizedBox(height: 4.h),

                // Emergency Contacts
                EmergencyContactsWidget(
                  onContactCalled: _onContactCalled,
                ),

                SizedBox(height: 4.h),

                // Medical Information
                const MedicalInfoWidget(),

                SizedBox(height: 6.h),

                // Bottom Actions
                if (!_isEmergencyActive) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/health-dashboard'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'Return to Dashboard',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isEmergencyActive = true;
                              _showSafeStatus = false;
                              _isCallConnected = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.error,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                          ),
                          child: Text(
                            'New Emergency',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
