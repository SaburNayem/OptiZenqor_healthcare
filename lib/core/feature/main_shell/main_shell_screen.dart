import 'package:flutter/material.dart';

import '../../../feature/appointments/appointment_screen/appointments_screen.dart';
import '../../../feature/home/home_screen/home_screen.dart';
import '../../../feature/profile/profile_screen/profile_screen.dart';
import '../../../feature/reports/report_screen/reports_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeScreen(),
    AppointmentsScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: _tabs[_currentIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_open_outlined),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
