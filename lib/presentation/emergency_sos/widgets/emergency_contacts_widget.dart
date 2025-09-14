import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmergencyContactsWidget extends StatelessWidget {
  final VoidCallback? onContactCalled;

  const EmergencyContactsWidget({
    super.key,
    this.onContactCalled,
  });

  final List<Map<String, dynamic>> _emergencyContacts = const [
    {
      "id": 1,
      "name": "Campus Security",
      "number": "(555) 123-4567",
      "type": "campus",
      "description": "24/7 Campus Emergency Response",
      "icon": "security",
      "priority": "high"
    },
    {
      "id": 2,
      "name": "Emergency Services",
      "number": "911",
      "type": "emergency",
      "description": "Police, Fire, Medical Emergency",
      "icon": "emergency",
      "priority": "critical"
    },
    {
      "id": 3,
      "name": "Campus Health Center",
      "number": "(555) 987-6543",
      "type": "medical",
      "description": "Medical Assistance & First Aid",
      "icon": "local_hospital",
      "priority": "high"
    },
    {
      "id": 4,
      "name": "Personal Emergency",
      "number": "(555) 456-7890",
      "type": "personal",
      "description": "Your Emergency Contact",
      "icon": "person",
      "priority": "medium"
    },
  ];

  void _makeCall(BuildContext context, Map<String, dynamic> contact) {
    HapticFeedback.heavyImpact();

    // Show confirmation dialog for non-emergency contacts
    if ((contact["type"] as String) != "emergency") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Call ${contact["name"]}?'),
          content: Text('Are you sure you want to call ${contact["number"]}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onContactCalled?.call();
                // In a real app, this would trigger the phone dialer
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling ${contact["name"]}...'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              child: const Text('Call'),
            ),
          ],
        ),
      );
    } else {
      // Direct call for emergency services
      onContactCalled?.call();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calling ${contact["name"]}...'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Color _getContactColor(BuildContext context, String priority) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (priority) {
      case "critical":
        return colorScheme.error;
      case "high":
        return colorScheme.primary;
      case "medium":
        return colorScheme.tertiary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contacts',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 3.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _emergencyContacts.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final contact = _emergencyContacts[index];
            final contactColor =
                _getContactColor(context, contact["priority"] as String);

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: contactColor.withValues(alpha: 0.2),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _makeCall(context, contact),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        // Contact Icon
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: contactColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: contact["icon"] as String,
                              color: contactColor,
                              size: 24,
                            ),
                          ),
                        ),

                        SizedBox(width: 4.w),

                        // Contact Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact["name"] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                contact["number"] as String,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: contactColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                contact["description"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Call Button
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: contactColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'phone',
                              color: colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
