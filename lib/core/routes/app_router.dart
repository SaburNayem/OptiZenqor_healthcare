import 'package:flutter/material.dart';

import '../../feature/appointments/appointment_screen/book_appointment_screen.dart';
import '../../feature/appointments/appointment_screen/booking_success_screen.dart';
import '../../feature/auth/auth_screen/auth_gate_screen.dart';
import '../../feature/auth/auth_screen/login_screen.dart';
import '../../feature/auth/auth_screen/register_screen.dart';
import '../../feature/doctors/doctors_screen/doctors_screen.dart';
import '../../feature/history/history_screen/history_screen.dart';
import '../../feature/notifications/notifications_screen/notifications_screen.dart';
import '../../feature/reports/report_screen/upload_report_screen.dart';
import '../../feature/symptom_checker/domain/models/symptom_result_model.dart';
import '../../feature/symptom_checker/symptom_checker_screen/emergency_alert_screen.dart';
import '../../feature/symptom_checker/symptom_checker_screen/symptom_checker_screen.dart';
import '../../feature/symptom_checker/symptom_checker_screen/symptom_result_screen.dart';
import '../feature/main_shell/main_shell_screen.dart';
import 'route_names.dart';

class AppRouter {
  static const String initialRoute = RouteNames.authGate;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.authGate:
        return _build(const AuthGateScreen(), settings);
      case RouteNames.login:
        return _build(const LoginScreen(), settings);
      case RouteNames.register:
        return _build(const RegisterScreen(), settings);
      case RouteNames.shell:
        return _build(const MainShellScreen(), settings);
      case RouteNames.symptomChecker:
        return _build(const SymptomCheckerScreen(), settings);
      case RouteNames.symptomResult:
        final result = settings.arguments as SymptomResultModel;
        return _build(SymptomResultScreen(result: result), settings);
      case RouteNames.emergencyAlert:
        final result = settings.arguments as SymptomResultModel;
        return _build(EmergencyAlertScreen(result: result), settings);
      case RouteNames.doctors:
        return _build(const DoctorsScreen(), settings);
      case RouteNames.bookAppointment:
        return _build(const BookAppointmentScreen(), settings);
      case RouteNames.bookingSuccess:
        return _build(const BookingSuccessScreen(), settings);
      case RouteNames.uploadReport:
        return _build(const UploadReportScreen(), settings);
      case RouteNames.history:
        return _build(const HistoryScreen(), settings);
      case RouteNames.notifications:
        return _build(const NotificationsScreen(), settings);
      default:
        return _build(
          const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _build(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => child,
      settings: settings,
    );
  }
}
