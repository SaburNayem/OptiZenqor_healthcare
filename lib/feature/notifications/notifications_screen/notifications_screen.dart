import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loader.dart';
import '../notifications_controller/notifications_controller.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: items.when(
        loading: () => const AppLoader(message: 'Loading notifications...'),
        error: (error, stackTrace) => AppErrorView(
          message: 'Could not load notifications',
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('No notifications right now. You are all caught up.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final color = switch (item.priority) {
                'HIGH' => AppColors.danger,
                'MEDIUM' => AppColors.warning,
                _ => AppColors.success,
              };
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              item.priority,
                              style: TextStyle(color: color, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item.message),
                      const SizedBox(height: 6),
                      Text(DateFormat('MMM d, hh:mm a').format(item.createdAt)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
