import 'package:faiapp/app/theme/app_colors.dart';
import 'package:faiapp/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppDestination {
  workspace('/workspace', 'Workspace', Icons.auto_awesome_rounded),
  settings('/settings', 'Settings', Icons.tune_rounded);

  const AppDestination(this.location, this.label, this.icon);

  final String location;
  final String label;
  final IconData icon;
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.destination, required this.child});

  final AppDestination destination;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showRail = constraints.maxWidth >= 900;
          final scaffoldBody = showRail
              ? Row(
                  children: [
                    _ShellRail(current: destination),
                    Expanded(child: child),
                  ],
                )
              : child;

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(child: scaffoldBody),
            bottomNavigationBar: showRail
                ? null
                : _ShellBottomNavigation(current: destination),
          );
        },
      ),
    );
  }
}

class _ShellRail extends StatelessWidget {
  const _ShellRail({required this.current});

  final AppDestination current;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      margin: const EdgeInsets.fromLTRB(24, 24, 0, 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: _BrandLockup(),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          for (final destination in AppDestination.values)
            _NavigationTile(
              destination: destination,
              isSelected: destination == current,
            ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Secure AI orchestration with backend-managed model calls.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShellBottomNavigation extends StatelessWidget {
  const _ShellBottomNavigation({required this.current});

  final AppDestination current;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: AppDestination.values.indexOf(current),
      onDestinationSelected: (index) {
        context.go(AppDestination.values[index].location);
      },
      destinations: [
        for (final destination in AppDestination.values)
          NavigationDestination(
            icon: Icon(destination.icon),
            label: destination.label,
          ),
      ],
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({required this.destination, required this.isSelected});

  final AppDestination destination;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: ListTile(
        onTap: () => context.go(destination.location),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: isSelected ? AppColors.paleTeal : Colors.transparent,
        leading: Icon(destination.icon, color: AppColors.primary),
        title: Text(
          destination.label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
          ),
          child: const Icon(Icons.hub_rounded, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text('Atlas AI', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 6),
        Text(
          'Planning workspace',
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
