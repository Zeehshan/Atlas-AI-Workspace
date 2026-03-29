import 'package:faiapp/core/config/app_config.dart';
import 'package:faiapp/core/widgets/empty_state_card.dart';
import 'package:faiapp/core/widgets/section_card.dart';
import 'package:faiapp/features/auth/presentation/controllers/auth_controller.dart';
import 'package:faiapp/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routePath = '/settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final settingsState = ref.watch(settingsControllerProvider);
    final config = ref.watch(appConfigProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 12),
            Text(
              'Inspect local app configuration, backend capabilities, and session information.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                SizedBox(
                  width: 380,
                  child: SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Application',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _SettingRow(label: 'Name', value: config.appName),
                        _SettingRow(
                          label: 'Environment',
                          value: config.environment,
                        ),
                        _SettingRow(
                          label: 'API base URL',
                          value: config.apiBaseUrl,
                        ),
                        _SettingRow(
                          label: 'Verbose logs',
                          value: config.enableVerboseLogs
                              ? 'Enabled'
                              : 'Disabled',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 380,
                  child: SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _SettingRow(
                          label: 'User',
                          value:
                              authState.session?.user.displayName ?? 'Unknown',
                        ),
                        _SettingRow(
                          label: 'Email',
                          value: authState.session?.user.email ?? 'Unknown',
                        ),
                        _SettingRow(
                          label: 'Roles',
                          value:
                              authState.session?.user.roles.join(', ') ??
                              'None',
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonal(
                          onPressed: () => ref
                              .read(authControllerProvider.notifier)
                              .signOut(),
                          child: const Text('Sign out'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (settingsState.isLoading)
              const SectionCard(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (settingsState.publicConfig case final publicConfig?)
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Backend capabilities',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _SettingRow(
                      label: 'Auth mode',
                      value: publicConfig.authMode,
                    ),
                    _SettingRow(
                      label: 'Default provider',
                      value: publicConfig.defaultProvider.label,
                    ),
                    _SettingRow(
                      label: 'Supported providers',
                      value: publicConfig.supportedProviders
                          .map((item) => item.label)
                          .join(', '),
                    ),
                    _SettingRow(
                      label: 'Genkit debug traces',
                      value: publicConfig.debugAiTracesEnabled
                          ? 'Enabled'
                          : 'Disabled',
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: controller.load,
                      child: const Text('Refresh backend config'),
                    ),
                  ],
                ),
              )
            else
              EmptyStateCard(
                icon: Icons.settings_suggest_rounded,
                title: 'Backend configuration unavailable',
                message:
                    settingsState.errorMessage ??
                    'No backend configuration was returned.',
              ),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
