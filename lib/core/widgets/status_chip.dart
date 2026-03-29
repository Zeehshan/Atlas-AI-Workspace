import 'package:faiapp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  factory StatusChip.success(String label, {IconData? icon}) {
    return StatusChip(label: label, color: AppColors.success, icon: icon);
  }

  factory StatusChip.info(String label, {IconData? icon}) {
    return StatusChip(label: label, color: AppColors.info, icon: icon);
  }

  factory StatusChip.warning(String label, {IconData? icon}) {
    return StatusChip(label: label, color: AppColors.accent, icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final value) ...[
            Icon(value, size: 16, color: color),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
