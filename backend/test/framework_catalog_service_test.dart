import 'package:atlas_ai_backend/src/ai/tools/framework_catalog_tool.dart';
import 'package:test/test.dart';

void main() {
  test('security keyword returns security framework guidance', () {
    const service = FrameworkCatalogService();

    final matches = service.lookup(
      initiativeType: 'product delivery',
      deliveryStage: 'build',
      frameworkKeywords: const ['security', 'prioritization'],
    );

    expect(matches.any((item) => item.name == 'Security Review Track'), isTrue);
  });
}
