import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

enum ReportOperation { submit, loadReports }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  ReportOperation _operation = ReportOperation.submit;
  String? _selectedCategory;
  bool _simulateFailure = false;
  int _simulatedReportCount = 0;

  bool get _isLoading => _uiState == ReportUiState.loading;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _operation = ReportOperation.submit;
      _uiState = ReportUiState.loading;
    });

    try {
      await Future<void>.delayed(const Duration(seconds: 3));

      if (_simulateFailure) {
        throw Exception('Simulated report submission failure');
      }

      if (!mounted) return;
      setState(() {
        _simulatedReportCount++;
        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  Future<void> _checkReports() async {
    setState(() {
      _operation = ReportOperation.loadReports;
      _uiState = ReportUiState.loading;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _uiState = _simulatedReportCount == 0
          ? ReportUiState.empty
          : ReportUiState.success;
    });
  }

  Future<void> _retrySubmission() async {
    setState(() => _simulateFailure = false);
    await _submitReport();
  }

  void _resetForAnotherReport() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
      _simulateFailure = false;
      _uiState = ReportUiState.idle;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Report Form')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Submit a Report',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'Report title',
                        hintText: 'Enter a short report title',
                        enabled: !_isLoading,
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) {
                            return 'Please enter a report title.';
                          }
                          if (text.length < 3) {
                            return 'The title must have at least 3 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'General Concern',
                            child: Text('General Concern'),
                          ),
                          DropdownMenuItem(
                            value: 'Facility Issue',
                            child: Text('Facility Issue'),
                          ),
                          DropdownMenuItem(
                            value: 'Service Concern',
                            child: Text('Service Concern'),
                          ),
                        ],
                        onChanged: _isLoading
                            ? null
                            : (value) =>
                                  setState(() => _selectedCategory = value),
                        validator: (value) =>
                            value == null ? 'Please choose a category.' : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _locationController,
                        label: 'Location',
                        hintText: 'Where did the concern happen?',
                        enabled: !_isLoading,
                        validator: (value) {
                          if ((value?.trim() ?? '').isEmpty) {
                            return 'Please enter a location.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hintText: 'Describe the concern clearly',
                        maxLines: 4,
                        enabled: !_isLoading,
                        validator: (value) {
                          final text = value?.trim() ?? '';
                          if (text.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (text.length < 10) {
                            return 'The description must have at least 10 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Simulate failure for Error state'),
                        value: _simulateFailure,
                        onChanged: _isLoading
                            ? null
                            : (value) =>
                                  setState(() => _simulateFailure = value),
                      ),
                      const SizedBox(height: 8),
                      AppButton(
                        label: 'Submit Report',
                        icon: Icons.send_outlined,
                        isLoading:
                            _isLoading && _operation == ReportOperation.submit,
                        onPressed: _isLoading ? null : _submitReport,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _checkReports,
                        icon: const Icon(Icons.list_alt_outlined),
                        label: const Text('Check Report Records'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildStateResponse(context),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildStateResponse(BuildContext context) {
    switch (_uiState) {
      case ReportUiState.idle:
        return _StateCard(
          icon: Icons.info_outline,
          title: 'Ready',
          message: '',
        );

      case ReportUiState.loading:
        final checkingReports = _operation == ReportOperation.loadReports;
        return _StateCard(
          showProgress: true,
          icon: Icons.hourglass_top,
          title: 'Loading',
          message: checkingReports
              ? 'Checking simulated report records. Please wait...'
              : 'Submitting the report. Duplicate submission is disabled while this request is pending.',
        );

      case ReportUiState.success:
        final loadedExisting = _operation == ReportOperation.loadReports;
        return _StateCard(
          icon: Icons.check_circle_outline,
          title: 'Success',
          message: loadedExisting
              ? '$_simulatedReportCount simulated report record(s) are available.'
              : 'The report submission completed successfully.',
          action: AppButton(
            label: 'Create Another Report',
            icon: Icons.add,
            onPressed: _resetForAnotherReport,
          ),
        );

      case ReportUiState.empty:
        return _StateCard(
          icon: Icons.inbox_outlined,
          title: 'Empty',
          message: 'No report records are available yet.',
          action: AppButton(
            label: 'Return to Form',
            icon: Icons.edit_outlined,
            onPressed: () => setState(() => _uiState = ReportUiState.idle),
          ),
        );

      case ReportUiState.error:
        return _StateCard(
          icon: Icons.error_outline,
          title: 'Error',
          message: 'The simulated submission failed. You can retry the same valid report or return to the form and correct the input.',
          action: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: 'Retry',
                icon: Icons.refresh,
                onPressed: _retrySubmission,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _uiState = ReportUiState.idle),
                child: const Text('Edit Form'),
              ),
            ],
          ),
        );
    }
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.showProgress = false,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool showProgress;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (showProgress)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              else
                Icon(icon, size: 28),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(message),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    ),
  );
}
