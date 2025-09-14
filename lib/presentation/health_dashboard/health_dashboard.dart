import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/emergency_sos_widget.dart';
import './widgets/health_status_card.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/service_category_card.dart';
import './widgets/weather_fitness_widget.dart';

class HealthDashboard extends StatefulWidget {
  const HealthDashboard({super.key});

  @override
  State<HealthDashboard> createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isRefreshing = false;
  int _currentBottomNavIndex = 0;

  // Mock user data
  final Map<String, dynamic> userData = {
    'name': 'Alex Johnson',
    'studentId': 'STU2024001',
    'email': 'alex.johnson@university.edu',
    'phone': '+1 (555) 123-4567',
    'emergencyContact': '+1 (555) 987-6543',
    'bloodType': 'O+',
    'allergies': ['Peanuts', 'Shellfish'],
    'medications': ['Vitamin D', 'Multivitamin'],
  };

  final Map<String, dynamic> healthData = {
    'status': 'Good',
    'heartRate': 72,
    'bloodPressure': '120/80',
    'weight': 70,
    'bmi': 22.5,
    'lastCheckup': '2024-08-15',
    'nextAppointment': '2024-09-20',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupScrollListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Handle scroll-based UI changes if needed
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Health data updated successfully'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildServicesTab(),
          _buildChatTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      title: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.health_and_safety_outlined,
              color: colorScheme.onPrimary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CampusWell',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Your health companion',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _buildNotificationIcon(),
        const EmergencySosWidget(),
        SizedBox(width: 4.w),
      ],
      bottom: TabBar(
        controller: _tabController,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        isScrollable: false,
        tabs: const [
          Tab(text: 'Home'),
          Tab(text: 'Services'),
          Tab(text: 'Chat'),
          Tab(text: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_outlined,
            color: colorScheme.onSurface,
            size: 6.w,
          ),
          onPressed: () {
            // Handle notifications
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: colorScheme.error,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '2',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onError,
                  fontWeight: FontWeight.w600,
                  fontSize: 7.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.primaryLight,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            _buildGreetingSection(),
            SizedBox(height: 3.h),
            HealthStatusCard(
              userName: userData['name'] as String,
              healthData: healthData,
            ),
            SizedBox(height: 3.h),
            const QuickActionsWidget(),
            SizedBox(height: 3.h),
            const WeatherFitnessWidget(),
            SizedBox(height: 3.h),
            const RecentActivityWidget(),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, ${userData['name']?.split(' ').first}',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'How can we help you stay healthy today?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    final List<Map<String, dynamic>> serviceCategories = [
      {
        'title': 'Medical Care',
        'description': 'Book appointments with healthcare professionals',
        'icon': Icons.medical_services_outlined,
        'color': AppTheme.primaryLight,
        'route': '/service-booking',
      },
      {
        'title': 'Mental Wellness',
        'description': 'Counseling and mental health support',
        'icon': Icons.psychology_outlined,
        'color': Color(0xFF7B1FA2),
        'route': '/service-booking',
      },
      {
        'title': 'Accessibility',
        'description': 'Wheelchair services and mobility support',
        'icon': Icons.accessible_outlined,
        'color': Color(0xFF00796B),
        'route': '/service-booking',
      },
      {
        'title': 'Fitness & Wellness',
        'description': 'Exercise programs and wellness activities',
        'icon': Icons.fitness_center_outlined,
        'color': Color(0xFFF57C00),
        'route': '/service-booking',
      },
      {
        'title': 'Pharmacy',
        'description': 'Order medications and prescriptions',
        'icon': Icons.local_pharmacy_outlined,
        'color': Color(0xFFD32F2F),
        'route': '/medicine-ordering',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),
          Text(
            'Health Services',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 1.h),
          Text(
            'Access comprehensive healthcare services',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          ...serviceCategories.map(
            (service) => _buildModernServiceCard(service),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildModernServiceCard(Map<String, dynamic> service) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, service['route'] as String);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Row(
              children: [
                Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color: (service['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    service['icon'] as IconData,
                    color: service['color'] as Color,
                    size: 7.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['title'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        service['description'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_outlined,
                color: colorScheme.primary,
                size: 12.w,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Health Support Chat',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Connect instantly with our healthcare team for guidance and support',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            FilledButton.icon(
              onPressed: () {
                // Navigate to chat screen
              },
              icon: const Icon(Icons.chat_outlined),
              label: const Text('Start Conversation'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          _buildProfileHeader(),
          SizedBox(height: 5.h),
          _buildProfileInfoCard('Personal Information', [
            _buildProfileRow(
              'Email',
              userData['email'] as String,
              Icons.email_outlined,
            ),
            _buildProfileRow(
              'Phone',
              userData['phone'] as String,
              Icons.phone_outlined,
            ),
            _buildProfileRow(
              'Student ID',
              userData['studentId'] as String,
              Icons.badge_outlined,
            ),
          ]),
          SizedBox(height: 3.h),
          _buildProfileInfoCard('Emergency Contact', [
            _buildProfileRow(
              'Contact',
              userData['emergencyContact'] as String,
              Icons.emergency_outlined,
            ),
          ]),
          SizedBox(height: 3.h),
          _buildProfileInfoCard('Health Information', [
            _buildProfileRow(
              'Blood Type',
              userData['bloodType'] as String,
              Icons.bloodtype_outlined,
            ),
            _buildProfileRow(
              'Allergies',
              (userData['allergies'] as List).join(', '),
              Icons.warning_amber_outlined,
            ),
            _buildProfileRow(
              'Medications',
              (userData['medications'] as List).join(', '),
              Icons.medication_outlined,
            ),
          ]),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (userData['name'] as String)[0],
              style: theme.textTheme.headlineLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          userData['name'] as String,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          userData['studentId'] as String,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfoCard(String title, List<Widget> children) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 5.w),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
