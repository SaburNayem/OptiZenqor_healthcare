import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/route_names.dart';
import '../../auth/auth_controller/auth_controller.dart';
import '../home_model/home_model.dart';

final homeProvider = Provider<HomeModel>((ref) {
	final user = ref.watch(authControllerProvider).user;
	final name = user?.name ?? 'Guest';
	final hour = DateTime.now().hour;
	final message = hour < 12
			? 'Good morning'
			: hour < 17
					? 'Good afternoon'
					: 'Good evening';

	return HomeModel(
		greeting: '$message, $name',
		quickActions: const [
			HomeQuickAction(
				title: 'Symptom Checker',
				icon: Icons.psychology_outlined,
				route: RouteNames.symptomChecker,
			),
			HomeQuickAction(
				title: 'Book Appointment',
				icon: Icons.calendar_month_outlined,
				route: RouteNames.bookAppointment,
			),
			HomeQuickAction(
				title: 'Upload Report',
				icon: Icons.upload_file_outlined,
				route: RouteNames.uploadReport,
			),
			HomeQuickAction(
				title: 'View History',
				icon: Icons.history,
				route: RouteNames.history,
			),
		],
	);
});

