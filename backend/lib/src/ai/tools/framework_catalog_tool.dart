class FrameworkCatalogMatch {
  const FrameworkCatalogMatch({
    required this.name,
    required this.reason,
    required this.application,
  });

  final String name;
  final String reason;
  final String application;
}

class FrameworkCatalogService {
  const FrameworkCatalogService();

  List<FrameworkCatalogMatch> lookup({
    required String initiativeType,
    required String deliveryStage,
    required List<String> frameworkKeywords,
  }) {
    final normalizedKeywords = frameworkKeywords
        .map((item) => item.toLowerCase())
        .toList();
    final stage = deliveryStage.toLowerCase();
    final initiative = initiativeType.toLowerCase();

    final matches = <FrameworkCatalogMatch>[
      if (initiative.contains('product') ||
          normalizedKeywords.contains('prioritization'))
        const FrameworkCatalogMatch(
          name: 'RICE Prioritization',
          reason:
              'Helps product teams rank scope by reach, impact, confidence, and effort.',
          application:
              'Use it to justify what lands in the beta versus later releases.',
        ),
      if (stage == 'discovery' || normalizedKeywords.contains('research'))
        const FrameworkCatalogMatch(
          name: 'JTBD Interview Map',
          reason:
              'Clarifies the user problem and desired outcomes before implementation.',
          application:
              'Use it to validate assumptions with target users and align scope.',
        ),
      if (stage == 'launch' || normalizedKeywords.contains('rollout'))
        const FrameworkCatalogMatch(
          name: 'Launch Readiness Checklist',
          reason:
              'Ensures operational, support, and communications work is not skipped.',
          application:
              'Use it to prepare go-live decisions and rollout sequencing.',
        ),
      if (normalizedKeywords.contains('security') ||
          normalizedKeywords.contains('compliance'))
        const FrameworkCatalogMatch(
          name: 'Security Review Track',
          reason:
              'Adds threat review, secrets handling, and operational hardening into delivery.',
          application:
              'Use it to include secret isolation, auditability, and environment review.',
        ),
      if (stage == 'scale' || normalizedKeywords.contains('analytics'))
        const FrameworkCatalogMatch(
          name: 'North Star Metric Tree',
          reason:
              'Connects adoption metrics to product and operational leading indicators.',
          application:
              'Use it to define success metrics and analytics milestones after beta.',
        ),
    ];

    return matches.isEmpty
        ? const [
            FrameworkCatalogMatch(
              name: 'Execution Backbone',
              reason:
                  'A generic planning scaffold for milestone-driven delivery.',
              application:
                  'Use it to align objectives, ownership, and success checkpoints.',
            ),
          ]
        : matches.take(3).toList(growable: false);
  }

  String lookupSummary({
    required String initiativeType,
    required String deliveryStage,
    required List<String> frameworkKeywords,
  }) {
    final matches = lookup(
      initiativeType: initiativeType,
      deliveryStage: deliveryStage,
      frameworkKeywords: frameworkKeywords,
    );

    return matches
        .map(
          (item) =>
              '${item.name}: ${item.reason} Application: ${item.application}',
        )
        .join('\n');
  }
}
