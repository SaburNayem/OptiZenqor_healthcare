import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feature/main_shell/main_shell_screen.dart';
import '../../../core/widgets/app_loader.dart';
import '../../auth/auth_controller/auth_controller.dart';
import 'login_screen.dart';

class AuthGateScreen extends ConsumerStatefulWidget {
  const AuthGateScreen({super.key});

  @override
  ConsumerState<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends ConsumerState<AuthGateScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(authControllerProvider.notifier).restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    if (authState.isLoading) {
      return const Scaffold(body: AppLoader(message: 'Checking session...'));
    }

    if (authState.isLoggedIn) {
      return const MainShellScreen();
    }

    return const LoginScreen();
  }
}
