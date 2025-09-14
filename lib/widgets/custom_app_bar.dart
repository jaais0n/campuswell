import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget for campus health application
/// Implements Contemporary Medical Minimalism design principles
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showEmergencyButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showEmergencyButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: foregroundColor ?? colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: [
        if (showEmergencyButton) _buildEmergencyButton(context),
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.emergency,
            color: Theme.of(context).colorScheme.onError,
            size: 20,
          ),
        ),
        onPressed: () {
          HapticFeedback.heavyImpact();
          Navigator.pushNamed(context, '/emergency-sos');
        },
        tooltip: 'Emergency SOS',
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Specialized app bar for health dashboard
class CustomHealthDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  const CustomHealthDashboardAppBar({
    super.key,
    required this.userName,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good ${_getTimeOfDay()},',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            userName,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      actions: [
        // Notification button
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 24),
              onPressed: onNotificationTap,
              tooltip: 'Notifications',
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    notificationCount > 99
                        ? '99+'
                        : notificationCount.toString(),
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onError,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        // Emergency SOS button
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.error,
                    colorScheme.error.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.error.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.emergency,
                color: colorScheme.onError,
                size: 20,
              ),
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.pushNamed(context, '/emergency-sos');
            },
            tooltip: 'Emergency SOS',
          ),
        ),
        // Profile button
        IconButton(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: colorScheme.primary,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          onPressed: onProfileTap,
          tooltip: 'Profile',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    } else if (hour < 17) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
