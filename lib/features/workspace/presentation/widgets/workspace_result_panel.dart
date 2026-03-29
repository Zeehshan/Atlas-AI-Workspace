import 'package:faiapp/app/theme/app_colors.dart';
import 'package:faiapp/core/widgets/empty_state_card.dart';
import 'package:faiapp/core/widgets/section_card.dart';
import 'package:faiapp/core/widgets/status_chip.dart';
import 'package:faiapp/features/workspace/domain/entities/workspace_plan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkspaceResultPanel extends StatelessWidget {
  const WorkspaceResultPanel({
    super.key,
    required this.plan,
    required this.isShowingCachedPlan,
  });

  final WorkspacePlan? plan;
  final bool isShowingCachedPlan;

  @override
  Widget build(BuildContext context) {
    if (plan == null) {
      return const EmptyStateCard(
        icon: Icons.auto_awesome_rounded,
        title: 'No plan generated yet',
        message:
            'Submit a goal to generate a structured execution plan from the backend Genkit workflow.',
      );
    }

    final theme = Theme.of(context);
    final dateLabel = DateFormat(
      'MMM d, y • HH:mm',
    ).format(plan!.generatedAt.toLocal());

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              StatusChip.success(
                plan!.provider.label,
                icon: Icons.bolt_rounded,
              ),
              StatusChip.info(plan!.model, icon: Icons.memory_rounded),
              if (isShowingCachedPlan)
                StatusChip.warning(
                  'Cached result',
                  icon: Icons.cloud_off_rounded,
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(plan!.executiveSummary, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Generated $dateLabel',
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 24),
          _TextSection(
            title: 'Problem statement',
            content: plan!.problemStatement,
          ),
          const SizedBox(height: 18),
          _TextSection(
            title: 'Recommended approach',
            content: plan!.recommendedApproach,
          ),
          const SizedBox(height: 24),
          Text('Milestones', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final milestone in plan!.milestones) ...[
            _TimelineCard(
              title: milestone.title,
              subtitle: '${milestone.timeframe} • ${milestone.owner}',
              body: milestone.outcome,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          Text('Risks', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final risk in plan!.risks) ...[
            _RiskCard(risk: risk),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          Text('Tool insights', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final insight in plan!.toolInsights)
                Chip(
                  label: SizedBox(
                    width: 220,
                    child: Text(
                      '${insight.name}: ${insight.reason}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Follow-up questions', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final question in plan!.followUpQuestions) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Text(question, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (plan!.debugInfo case final debugInfo?) ...[
            const SizedBox(height: 24),
            Text('Debug info', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Prompt ${debugInfo.promptVersion} • ${debugInfo.correlationId} • ${debugInfo.latencyMs} ms',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TextSection extends StatelessWidget {
  const _TextSection({required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(content, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.title,
    required this.subtitle,
    required this.body,
  });

  final String title;
  final String subtitle;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paleBlue.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          Text(body, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  const _RiskCard({required this.risk});

  final WorkspaceRisk risk;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.paleGold.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${risk.title} • ${risk.severity}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(risk.mitigation),
        ],
      ),
    );
  }
}
