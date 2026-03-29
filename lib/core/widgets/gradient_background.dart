import 'package:faiapp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.canvas, AppColors.paleGold, AppColors.paleBlue],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -120,
            right: -60,
            child: _Orb(
              size: 260,
              color: AppColors.paleTeal.withValues(alpha: 0.68),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -40,
            child: _Orb(
              size: 220,
              color: AppColors.paleGold.withValues(alpha: 0.75),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(blurRadius: 80, color: color.withValues(alpha: 0.6)),
        ],
      ),
    );
  }
}
