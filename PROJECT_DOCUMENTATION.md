# OptiZenqor Healthcare App Documentation

## 1. Project Overview
OptiZenqor Healthcare is a safety-first Flutter mobile app for healthcare diagnostics support, doctor discovery, appointment workflows, and report intelligence.

The app is designed around a strict principle:
- Patient safety first
- Clear non-diagnostic guidance
- Emergency escalation when risk signals are detected
- Clean and understandable UX for all users, including elderly users

## 2. Tech Stack
- Flutter (stable)
- Dart SDK 3.10.x
- State management: flutter_riverpod
- Local storage: shared_preferences
- Formatting/time handling: intl

## 3. Architecture
The project follows feature-based clean architecture with API-ready service abstractions.

### 3.1 Key Principles
- Feature-first structure
- Domain, data, and presentation separation
- Centralized routing and design system
- Riverpod providers and StateNotifier controllers
- Mock services designed to be replaced by backend clients later

### 3.2 Project Structure
lib/
- app.dart
- main.dart
- core/
  - feature/main_shell/
  - routes/
  - services/
  - theme/
  - widgets/
- feature/
  - auth/
  - home/
  - symptom_checker/
  - doctors/
  - appointments/
  - reports/
  - history/
  - notifications/
  - profile/

## 4. App Flow
1. App starts with ProviderScope
2. Auth gate restores local session
3. If authenticated, user enters bottom nav shell
4. If not authenticated, user enters login/register flow
5. User navigates through Home, Appointments, Reports, Profile

## 5. Safety and Trust Layer
The app applies safety protections in multiple places:
- Result disclaimer always shown: This is not a medical diagnosis
- Confidence level shown in symptom results
- Consult Doctor CTA present in critical health decision screens
- Emergency detection route for severe symptom combinations
- Safe fallback actions in all risk scenarios

## 6. Core Features

### 6.1 Authentication
- Email/password login and register
- Session persistence with local storage
- Auth gate restore on startup
- Logout flow

### 6.2 Home Dashboard
- Personalized greeting
- Quick action cards:
  - Symptom Checker
  - Book Appointment
  - Upload Report
  - View History
- Notification badge
- Appointment summary card

### 6.3 Smart Symptom Checker (Upgraded)
The symptom checker is now a guided 4-step flow:
1. Patient details
   - age
   - gender
   - symptom duration
   - severity scale
2. Symptom selection
3. Dynamic safety questions
   - shown only when risk-relevant symptoms are selected
4. Analysis and safety output

Output includes:
- Possible conditions with cautious wording
- Suggested doctor type
- Urgency levels:
  - LOW
  - MEDIUM
  - HIGH
  - CRITICAL
- Confidence level (LOW/MEDIUM/HIGH)
- Safety action checklist
- Disclaimer

Emergency detection triggers an immediate Emergency Alert screen when risk criteria are met (for example chest pain plus dangerous signals).

### 6.4 Emergency Alert Flow
If CRITICAL risk is detected:
- Red highlighted emergency screen is shown
- User is instructed to go to nearest hospital or call emergency services
- Consult Doctor fallback CTA remains available

### 6.5 Doctor Matching System
Doctor data now includes:
- specialization
- rating
- experience
- availability status
- next available time

A Smart Recommendation card appears when doctor type is suggested from symptom analysis.

### 6.6 Appointment UX (Real-Time Style)
- Doctor-specific available slots only
- Date-based slot loading
- Instant booking confirmation
- Lifecycle status model:
  - upcoming
  - ongoing
  - completed
  - cancelled

### 6.7 Report Intelligence
When uploading reports, mock intelligence now provides:
- Report type detection (for example blood test, x-ray, ECG)
- AI-style summary (mock)
- Highlighted abnormal values (mock)
- Confidence label
- Disclaimer retained for safety

### 6.8 History
- Unified timeline from:
  - appointment records
  - symptom check records
- Sorted latest first

### 6.9 Notifications (Upgraded)
Smart reminders include:
- Appointment reminders
- Follow-up reminders
- Report attention alerts

Notifications include:
- Priority labels: HIGH, MEDIUM, LOW
- Type categories
- Time metadata

### 6.10 Profile + Health Summary
Profile now includes:
- user details
- recent symptoms
- last appointment
- report summary with abnormal marker count

## 7. Routing
Routing is managed through central route files in core/routes.

Main routes:
- /
- /login
- /register
- /shell
- /symptom-checker
- /symptom-result
- /emergency-alert
- /doctors
- /book-appointment
- /booking-success
- /upload-report
- /history
- /notifications

## 8. Riverpod State Design
Examples of primary providers:
- authControllerProvider
- symptomCheckerControllerProvider
- doctorsControllerProvider
- appointmentControllerProvider
- reportControllerProvider
- historyProvider
- notificationsProvider

This design keeps UI reactive and makes backend migration straightforward.

## 9. Mock Services and Backend Readiness
Current mock services:
- AuthService
- SymptomService
- DoctorService
- AppointmentService
- ReportService
- HistoryService
- NotificationService

Migration path:
1. Add repository interfaces in domain layer
2. Bind API repositories in Riverpod providers
3. Keep controllers and UI stable
4. Add DTO/model mappers
5. Add secure auth token flow and refresh handling

## 10. UX Standards Implemented
- Calming blue/green healthcare visual language
- Red reserved for emergency/critical alerts
- Card-based clear layout
- Progress indicators in symptom flow
- Clear CTAs and safe wording
- Empty state and recovery UI for no-data and failures

## 11. Setup and Run
Prerequisites:
- Flutter SDK
- Dart SDK
- Android Studio or Xcode

Commands:
- flutter pub get
- flutter run
- flutter analyze
- flutter test

## 12. Quality Status
- Analyzer: clean
- Widget tests: passing

## 13. Production Hardening Recommendations
- Replace local session storage with secure token storage
- Add API authentication and refresh-token strategy
- Add server-driven doctor availability and slot locking
- Add robust report parsing pipelines
- Add integration tests for emergency logic and booking race cases
- Add observability and analytics with privacy-safe event tracking

## 14. Maintenance Guidelines
For any new feature:
- add domain models
- add data service or repository
- add controller/provider
- add presentation screens
- register route if needed
- reuse core theme/widgets and safety disclaimers

Maintain the same pattern to keep the app scalable, consistent, and safe.
