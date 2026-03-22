import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../report_controller/report_controller.dart';

class UploadReportScreen extends ConsumerStatefulWidget {
  const UploadReportScreen({super.key});

  @override
  ConsumerState<UploadReportScreen> createState() => _UploadReportScreenState();
}

class _UploadReportScreenState extends ConsumerState<UploadReportScreen> {
  final _fileNameController = TextEditingController();
  String _fileType = 'PDF';

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportControllerProvider);
    final controller = ref.read(reportControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Report intelligence is a mock assistive summary. This is not a medical diagnosis.',
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _fileNameController,
            label: 'File name',
            hint: 'e.g. Blood_Test_March',
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _fileType,
            decoration: const InputDecoration(labelText: 'File type'),
            items: const [
              DropdownMenuItem(value: 'PDF', child: Text('PDF')),
              DropdownMenuItem(value: 'Image', child: Text('Image')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _fileType = value);
              }
            },
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            text: 'Upload',
            isLoading: state.isLoading,
            onPressed: () async {
              final fileName = _fileNameController.text.trim();
              if (fileName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter file name')),
                );
                return;
              }
              final ok = await controller.uploadReport(fileName: fileName, fileType: _fileType);
              if (!context.mounted) {
                return;
              }
              if (ok) {
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ref.read(reportControllerProvider).errorMessage ?? 'Upload failed'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
