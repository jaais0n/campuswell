import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom bottom navigation bar for campus health application
/// Implements Contemporary Medical Minimalism with adaptive navigation
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool hideOnScroll;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.hideOnScroll = false,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isVisible = true;

  final List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/health-dashboard',
    ),
    BottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Booking',
      route: '/service-booking',
    ),
    BottomNavItem(
      icon: Icons.medical_services_outlined,
      activeIcon: Icons.medical_services,
      label: 'Medicine',
      route: '/medicine-ordering',
    ),
    BottomNavItem(
      icon: Icons.emergency_outlined,
      activeIcon: Icons.emergency,
      label: 'Emergency',
      route: '/emergency-sos',
      isEmergency: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _hideBottomBar() {
    if (_isVisible && widget.hideOnScroll) {
      setState(() {
        _isVisible = false;
      });
      _animationController.reverse();
    }
  }

  void _showBottomBar() {
    if (!_isVisible && widget.hideOnScroll) {
      setState(() {
        _isVisible = true;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 72,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _navItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = widget.currentIndex == index;

                    return _buildNavItem(
                      context,
                      item,
                      isSelected,
                      index,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color itemColor;
    if (item.isEmergency) {
      itemColor = isSelected
          ? colorScheme.error
          : colorScheme.error.withValues(alpha: 0.6);
    } else {
      itemColor =
          isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();

          if (widget.onTap != null) {
            widget.onTap!(index);
          }

          // Navigate to the corresponding route
          if (ModalRoute.of(context)?.settings.name != item.route) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              item.route,
              (route) => false,
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? (item.isEmergency
                    ? colorScheme.error.withValues(alpha: 0.1)
                    : colorScheme.primary.withValues(alpha: 0.1))
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with special treatment for emergency
              if (item.isEmergency && isSelected)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.error.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.activeIcon,
                    size: 20,
                    color: colorScheme.onError,
                  ),
                )
              else
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 24,
                  color: itemColor,
                ),
              const SizedBox(height: 4),
              // Label
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: itemColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data class for bottom navigation items
class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final bool isEmergency;

  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.isEmergency = false,
  });
}

/// Floating bottom navigation bar variant for immersive experiences
class CustomFloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomFloatingBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/health-dashboard',
    ),
    BottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Booking',
      route: '/service-booking',
    ),
    BottomNavItem(
      icon: Icons.medical_services_outlined,
      activeIcon: Icons.medical_services,
      label: 'Medicine',
      route: '/medicine-ordering',
    ),
    BottomNavItem(
      icon: Icons.emergency_outlined,
      activeIcon: Icons.emergency,
      label: 'Emergency',
      route: '/emergency-sos',
      isEmergency: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = currentIndex == index;

          return _buildFloatingNavItem(
            context,
            item,
            isSelected,
            index,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFloatingNavItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color itemColor;
    if (item.isEmergency) {
      itemColor = isSelected
          ? colorScheme.error
          : colorScheme.error.withValues(alpha: 0.6);
    } else {
      itemColor =
          isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();

        if (onTap != null) {
          onTap!(index);
        }

        if (ModalRoute.of(context)?.settings.name != item.route) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            item.route,
            (route) => false,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? (item.isEmergency
                  ? colorScheme.error.withValues(alpha: 0.1)
                  : colorScheme.primary.withValues(alpha: 0.1))
              : Colors.transparent,
        ),
        child: Icon(
          isSelected ? item.activeIcon : item.icon,
          size: 24,
          color: itemColor,
        ),
      ),
    );
  }
}
