import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_loader.dart';
import '../report_controller/report_controller.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportControllerProvider);
    final controller = ref.read(reportControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.uploadReport),
            icon: const Icon(Icons.upload_file_outlined),
          ),
        ],
      ),
      body: state.isLoading
          ? const AppLoader(message: 'Loading reports...')
          : state.errorMessage != null
              ? AppErrorView(message: state.errorMessage!, onRetry: controller.loadReports)
              : state.reports.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('No reports uploaded yet'),
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pushNamed(RouteNames.uploadReport),
                            child: const Text('Upload report'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.loadReports,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.reports.length,
                        itemBuilder: (context, index) {
                          final report = state.reports[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: AppCard(
                              child: Row(
                                children: [
                                  Icon(
                                    report.fileType == 'PDF'
                                        ? Icons.picture_as_pdf_outlined
                                        : Icons.image_outlined,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report.fileName,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        Text(
                                          '${report.fileType} - ${DateFormat('MMM d, yyyy').format(report.uploadedAt)}',
                                        ),
                                        Text('Detected: ${report.detectedType}'),
                                        Text('AI confidence: ${report.confidence}'),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Report Preview'),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(report.aiSummary),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    'This is not a medical diagnosis.',
                                                    style: TextStyle(fontWeight: FontWeight.w700),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  if (report.abnormalFindings.isNotEmpty) ...[
                                                    const Text('Abnormal values:'),
                                                    const SizedBox(height: 6),
                                                    ...report.abnormalFindings.map(
                                                      (finding) => Container(
                                                        margin: const EdgeInsets.only(bottom: 6),
                                                        padding: const EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: AppColors.danger.withValues(alpha: 0.1),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(finding),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Preview'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
