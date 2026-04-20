import 'package:faiapp/core/providers/core_providers.dart';
import 'package:faiapp/core/widgets/section_card.dart';
import 'package:faiapp/core/widgets/status_chip.dart';
import 'package:faiapp/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:faiapp/features/workspace/presentation/widgets/workspace_form.dart';
import 'package:faiapp/features/workspace/presentation/widgets/workspace_result_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  static const routePath = '/workspace';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspaceState = ref.watch(workspaceControllerProvider);
    final isConnected = ref
        .watch(connectionStatusProvider)
        .maybeWhen(data: (value) => value, orElse: () => true);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600 ? 16.0 : 24.0;
    final verticalPadding = screenWidth < 600 ? 16.0 : 24.0;

    ref.listen(
      workspaceControllerProvider.select((value) => value.errorMessage),
      (previous, next) {
        if (next == null || next == previous) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next)));
      },
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding + 8,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1440),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 1100;
            final leftPane = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WorkspaceHero(isConnected: isConnected),
                const SizedBox(height: 24),
                SectionCard(
                  child: WorkspaceForm(
                    isSubmitting: workspaceState.isSubmitting,
                    onSubmit: (draft) {
                      ref
                          .read(workspaceControllerProvider.notifier)
                          .generatePlan(draft);
                    },
                  ),
                ),
              ],
            );

            final rightPane = WorkspaceResultPanel(
              plan: workspaceState.latestPlan,
              isShowingCachedPlan: workspaceState.isShowingCachedPlan,
            );

            return stacked
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftPane,
                      const SizedBox(height: 20),
                      rightPane,
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: leftPane),
                      const SizedBox(width: 24),
                      Expanded(flex: 7, child: rightPane),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _WorkspaceHero extends StatelessWidget {
  const _WorkspaceHero({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            StatusChip.success(
              'Genkit backend',
              icon: Icons.cloud_done_rounded,
            ),
            isConnected
                ? StatusChip.info('Network connected', icon: Icons.wifi_rounded)
                : StatusChip.warning(
                    'Offline mode',
                    icon: Icons.wifi_off_rounded,
                  ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Plan your initiative',
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 34),
        ),
        const SizedBox(height: 12),
        Text(
          'Turn a product, delivery, or operations brief into a structured execution plan with milestones, risks, and rollout guidance.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
