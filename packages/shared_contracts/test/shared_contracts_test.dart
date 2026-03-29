import 'package:shared_contracts/shared_contracts.dart';
import 'package:test/test.dart';

void main() {
  test('workspace plan request round-trips through json', () {
    const request = WorkspacePlanRequest(
      goal: 'Launch an AI roadmap assistant for enterprise product teams.',
      targetAudience: 'Product and engineering managers',
      successDefinition:
          'Ship a beta in 6 weeks with clear rollout milestones.',
      constraints: ['SOC2 aligned', 'Mobile-first experience'],
      notes: 'Needs scalable backend orchestration.',
      preferredProvider: AiProviderOption.openai,
    );

    final decoded = WorkspacePlanRequest.fromJson(request.toJson());

    expect(decoded.goal, request.goal);
    expect(decoded.constraints, request.constraints);
    expect(decoded.preferredProvider, request.preferredProvider);
  });
}
