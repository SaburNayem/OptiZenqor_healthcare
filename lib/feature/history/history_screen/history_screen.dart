import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loader.dart';
import '../history_controller/history_controller.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: history.when(
        loading: () => const AppLoader(message: 'Loading history...'),
        error: (error, stackTrace) => AppErrorView(
          message: 'Could not load history',
          onRetry: () => ref.invalidate(historyProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No history available yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(item.subtitle),
                      const SizedBox(height: 4),
                      Text(DateFormat('MMM d, yyyy - hh:mm a').format(item.dateTime)),
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
