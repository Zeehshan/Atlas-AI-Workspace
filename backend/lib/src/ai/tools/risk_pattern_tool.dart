class RiskPatternMatch {
  const RiskPatternMatch({
    required this.title,
    required this.severity,
    required this.mitigation,
  });

  final String title;
  final String severity;
  final String mitigation;
}

class RiskPatternService {
  const RiskPatternService();

  List<RiskPatternMatch> lookup({
    required String primaryRiskTheme,
    required List<String> constraints,
    required String goal,
  }) {
    final normalizedTheme = primaryRiskTheme.toLowerCase();
    final normalizedConstraints = constraints
        .map((item) => item.toLowerCase())
        .join(' ');
    final normalizedGoal = goal.toLowerCase();

    final matches = <RiskPatternMatch>[
      if (normalizedTheme.contains('security') ||
          normalizedConstraints.contains('api key'))
        const RiskPatternMatch(
          title: 'Secret leakage risk',
          severity: 'high',
          mitigation:
              'Keep provider credentials server-side, enforce config scanning, and gate releases with secret review.',
        ),
      if (normalizedConstraints.contains('mobile') ||
          normalizedGoal.contains('web'))
        const RiskPatternMatch(
          title: 'Cross-platform drift',
          severity: 'medium',
          mitigation:
              'Define shared contracts, responsive UI acceptance criteria, and platform QA checkpoints.',
        ),
      if (normalizedTheme.contains('adoption') ||
          normalizedGoal.contains('beta'))
        const RiskPatternMatch(
          title: 'Weak beta feedback loop',
          severity: 'medium',
          mitigation:
              'Instrument analytics early, capture qualitative feedback, and schedule structured pilot reviews.',
        ),
      if (normalizedConstraints.contains('compliance') ||
          normalizedTheme.contains('compliance'))
        const RiskPatternMatch(
          title: 'Compliance gap',
          severity: 'high',
          mitigation:
              'Add security review, audit logging, and deployment environment controls before launch.',
        ),
    ];

    return matches.isEmpty
        ? const [
            RiskPatternMatch(
              title: 'Execution ambiguity',
              severity: 'medium',
              mitigation:
                  'Lock owners, milestone outcomes, and release criteria early.',
            ),
          ]
        : matches.take(3).toList(growable: false);
  }

  String lookupSummary({
    required String primaryRiskTheme,
    required List<String> constraints,
    required String goal,
  }) {
    final matches = lookup(
      primaryRiskTheme: primaryRiskTheme,
      constraints: constraints,
      goal: goal,
    );

    return matches
        .map((item) => '${item.title} (${item.severity}): ${item.mitigation}')
        .join('\n');
  }
}
