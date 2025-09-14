import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/appointment_summary_card.dart';
import './widgets/appointment_type_selector.dart';
import './widgets/calendar_widget.dart';
import './widgets/service_type_selector.dart';
import './widgets/special_requirements_field.dart';
import './widgets/time_slot_bottom_sheet.dart';

class ServiceBooking extends StatefulWidget {
  const ServiceBooking({super.key});

  @override
  State<ServiceBooking> createState() => _ServiceBookingState();
}

class _ServiceBookingState extends State<ServiceBooking>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;
  String _selectedService = 'doctor';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  Map<String, dynamic>? _selectedSlot;
  String _selectedAppointmentType = 'initial';
  String _specialRequirements = '';
  bool _isLoading = false;

  final List<DateTime> _availableDates = [
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 5)),
    DateTime.now().add(const Duration(days: 7)),
    DateTime.now().add(const Duration(days: 8)),
    DateTime.now().add(const Duration(days: 10)),
    DateTime.now().add(const Duration(days: 12)),
    DateTime.now().add(const Duration(days: 14)),
    DateTime.now().add(const Duration(days: 15)),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
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
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  void _showTimeSlots() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimeSlotBottomSheet(
        selectedDate: _selectedDate,
        serviceType: _selectedService,
        onSlotSelected: (slot) {
          setState(() {
            _selectedSlot = slot;
          });
          _nextStep();
        },
      ),
    );
  }

  Future<void> _bookAppointment() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      _showBookingConfirmation();
    }
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Appointment Booked!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your appointment has been successfully scheduled. You will receive a confirmation email shortly.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/health-dashboard',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Go to Dashboard',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceedToNext() {
    switch (_currentStep) {
      case 0:
        return _selectedService.isNotEmpty;
      case 1:
        return _selectedSlot != null;
      case 2:
        return _selectedAppointmentType.isNotEmpty;
      case 3:
        return true; // Special requirements are optional
      case 4:
        return _selectedSlot != null && _selectedAppointmentType.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: _previousStep,
              )
            : IconButton(
                icon: CustomIconWidget(
                  iconName: 'arrow_back_ios',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text(
          'Book Appointment',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentStep + 1}/5',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Service Selection
                  SingleChildScrollView(
                    child: ServiceTypeSelector(
                      selectedService: _selectedService,
                      onServiceChanged: (service) {
                        setState(() {
                          _selectedService = service;
                          _selectedSlot =
                              null; // Reset slot when service changes
                        });
                      },
                    ),
                  ),

                  // Step 2: Date & Time Selection
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        CalendarWidget(
                          selectedDate: _selectedDate,
                          onDateSelected: (date) {
                            setState(() {
                              _selectedDate = date;
                              _selectedSlot =
                                  null; // Reset slot when date changes
                            });
                          },
                          availableDates: _availableDates,
                        ),
                        SizedBox(height: 2.h),
                        if (_availableDates.any((date) =>
                            date.year == _selectedDate.year &&
                            date.month == _selectedDate.month &&
                            date.day == _selectedDate.day))
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _showTimeSlots,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'View Available Time Slots',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),

                  // Step 3: Appointment Type
                  SingleChildScrollView(
                    child: AppointmentTypeSelector(
                      selectedType: _selectedAppointmentType,
                      onTypeChanged: (type) {
                        setState(() {
                          _selectedAppointmentType = type;
                        });
                      },
                    ),
                  ),

                  // Step 4: Special Requirements
                  SingleChildScrollView(
                    child: SpecialRequirementsField(
                      requirements: _specialRequirements,
                      onRequirementsChanged: (requirements) {
                        setState(() {
                          _specialRequirements = requirements;
                        });
                      },
                    ),
                  ),

                  // Step 5: Summary & Confirmation
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        AppointmentSummaryCard(
                          serviceType: _selectedService,
                          selectedDate: _selectedDate,
                          selectedSlot: _selectedSlot,
                          appointmentType: _selectedAppointmentType,
                          requirements: _specialRequirements,
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action button
            if (_currentStep < 4)
              Container(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canProceedToNext() ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 1 && _selectedSlot == null
                          ? 'Select Time Slot'
                          : 'Continue',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: EdgeInsets.all(4.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _bookAppointment,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Book Appointment',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: List.generate(5, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  if (index < 4) SizedBox(width: 1.w),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
