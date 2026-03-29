import 'package:faiapp/features/workspace/domain/entities/workspace_plan.dart';
import 'package:flutter/material.dart';
import 'package:shared_contracts/shared_contracts.dart';

class WorkspaceForm extends StatefulWidget {
  const WorkspaceForm({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final ValueChanged<WorkspaceDraft> onSubmit;

  @override
  State<WorkspaceForm> createState() => _WorkspaceFormState();
}

class _WorkspaceFormState extends State<WorkspaceForm> {
  static const _providerChoices = [
    AiProviderOption.google,
    AiProviderOption.anthropic,
  ];

  final _formKey = GlobalKey<FormState>();
  final _goalController = TextEditingController(
    text:
        'Launch an AI planning workspace for product and engineering leaders.',
  );
  final _audienceController = TextEditingController(
    text: 'Product managers, engineering managers, and solution architects',
  );
  final _successController = TextEditingController(
    text:
        'Ship a secure beta in six weeks with measurable adoption and clear rollout milestones.',
  );
  final _constraintsController = TextEditingController(
    text:
        'No API keys in the client\nBackend-managed model access\nNeed web and mobile support',
  );
  final _notesController = TextEditingController(
    text:
        'The app should support future analytics, role-based access, and prompt versioning.',
  );
  AiProviderOption _selectedProvider = AiProviderOption.google;

  @override
  void dispose() {
    _goalController.dispose();
    _audienceController.dispose();
    _successController.dispose();
    _constraintsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create a workspace plan',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'This form sends structured input to the backend Genkit flow. The backend handles prompt orchestration, tool usage, validation, and provider selection.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _goalController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Goal'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _audienceController,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Target audience'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _successController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Success definition'),
            validator: _requiredValidator,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AiProviderOption>(
            initialValue: _selectedProvider,
            decoration: const InputDecoration(labelText: 'Preferred provider'),
            items: [
              for (final provider in _providerChoices)
                DropdownMenuItem(value: provider, child: Text(provider.label)),
            ],
            onChanged: widget.isSubmitting
                ? null
                : (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _selectedProvider = value);
                  },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _constraintsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Constraints',
              hintText: 'Add one constraint per line',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Additional notes'),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: widget.isSubmitting
                ? null
                : () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    widget.onSubmit(
                      WorkspaceDraft(
                        goal: _goalController.text,
                        targetAudience: _audienceController.text,
                        successDefinition: _successController.text,
                        constraints: _constraintsController.text
                            .split(RegExp(r'[\n,]+'))
                            .map((item) => item.trim())
                            .where((item) => item.isNotEmpty)
                            .toList(growable: false),
                        notes: _notesController.text,
                        preferredProvider: _selectedProvider,
                      ),
                    );
                  },
            child: widget.isSubmitting
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Generate plan'),
          ),
        ],
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }
}
