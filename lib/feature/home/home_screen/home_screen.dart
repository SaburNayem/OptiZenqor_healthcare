import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/widgets/app_card.dart';
import '../../appointments/appointment_controller/appointment_controller.dart';
import '../../notifications/notifications_controller/notifications_controller.dart';
import '../home_controller/home_controller.dart';

class HomeScreen extends ConsumerWidget {
	const HomeScreen({super.key});

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final homeData = ref.watch(homeProvider);
		final appointmentState = ref.watch(appointmentControllerProvider);
		final notificationsAsync = ref.watch(notificationsProvider);
		final notificationCount = notificationsAsync.maybeWhen(
			data: (items) => items.length,
			orElse: () => 0,
		);

		return SafeArea(
			child: RefreshIndicator(
				onRefresh: () async {
					await ref.read(appointmentControllerProvider.notifier).loadAppointments();
				},
				child: ListView(
					padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
					children: [
						Row(
							children: [
								Expanded(
									child: Text(
										homeData.greeting,
										style: Theme.of(context).textTheme.headlineSmall,
									),
								),
								IconButton(
									onPressed: () {
										Navigator.of(context).pushNamed(RouteNames.notifications);
									},
									icon: Badge(
										label: Text('$notificationCount'),
										isLabelVisible: notificationCount > 0,
										child: const Icon(Icons.notifications_none_outlined),
									),
								),
							],
						),
						const SizedBox(height: 16),
						GridView.builder(
							shrinkWrap: true,
							physics: const NeverScrollableScrollPhysics(),
							itemCount: homeData.quickActions.length,
							gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
								crossAxisCount: 2,
								mainAxisSpacing: 10,
								crossAxisSpacing: 10,
								childAspectRatio: 1.35,
							),
							itemBuilder: (context, index) {
								final action = homeData.quickActions[index];
								return TweenAnimationBuilder<double>(
									duration: Duration(milliseconds: 240 + (index * 70)),
									tween: Tween(begin: 0.9, end: 1),
									builder: (context, value, child) {
										return Transform.scale(scale: value, child: child);
									},
									child: AppCard(
										onTap: () {
											Navigator.of(context).pushNamed(action.route);
										},
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Icon(action.icon, size: 28),
												const Spacer(),
												Text(
													action.title,
													style: Theme.of(context).textTheme.titleMedium,
												),
											],
										),
									),
								);
							},
						),
						const SizedBox(height: 14),
						AppCard(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										'Upcoming appointments',
										style: Theme.of(context).textTheme.titleMedium,
									),
									const SizedBox(height: 8),
									Text(
										appointmentState.appointments.isEmpty
												? 'No upcoming appointments. Book one now to stay on track.'
												: '${appointmentState.appointments.length} appointment(s) scheduled',
									),
								],
							),
						),
					],
				),
			),
		);
	}
}

