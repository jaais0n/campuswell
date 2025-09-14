import 'package:flutter/material.dart';
import '../presentation/emergency_sos/emergency_sos.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/service_booking/service_booking.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/medicine_ordering/medicine_ordering.dart';
import '../presentation/health_dashboard/health_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String emergencySos = '/emergency-sos';
  static const String splash = '/splash-screen';
  static const String serviceBooking = '/service-booking';
  static const String login = '/login-screen';
  static const String medicineOrdering = '/medicine-ordering';
  static const String healthDashboard = '/health-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    emergencySos: (context) => const EmergencySos(),
    splash: (context) => const SplashScreen(),
    serviceBooking: (context) => const ServiceBooking(),
    login: (context) => const LoginScreen(),
    medicineOrdering: (context) => const MedicineOrdering(),
    healthDashboard: (context) => const HealthDashboard(),
    // TODO: Add your other routes here
  };
}
