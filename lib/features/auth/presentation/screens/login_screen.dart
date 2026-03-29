import 'package:faiapp/core/widgets/gradient_background.dart';
import 'package:faiapp/core/widgets/section_card.dart';
import 'package:faiapp/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routePath = '/login';

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, viewportConstraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight - 48,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1080),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final stacked = constraints.maxWidth < 860;
                          return stacked
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    _HeroPanel(),
                                    SizedBox(height: 24),
                                    _FormPanel(),
                                  ],
                                )
                              : const Row(
                                  children: [
                                    Expanded(flex: 6, child: _HeroPanel()),
                                    SizedBox(width: 24),
                                    Expanded(flex: 5, child: _FormPanel()),
                                  ],
                                );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Atlas AI', style: theme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Text(
            'A full-stack Flutter and Genkit workspace for secure, typed AI planning.',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          Text(
            'Structured prompts, backend-only model execution, typed request and response contracts, and architecture built for future roles, analytics, and advanced flows.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel();

  @override
  Widget build(BuildContext context) {
    return const SectionCard(padding: EdgeInsets.all(28), child: LoginForm());
  }
}
