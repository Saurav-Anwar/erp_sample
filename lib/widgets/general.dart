import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

Widget sectionDivider() {
  return SizedBox(height: 14,);
}

Widget genericKPI({required String label, required String value}) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.textStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: AppTheme.textStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget sectionHeader({required String title, Widget? trailing}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTheme.textStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        if(trailing != null)...[
          trailing,
        ],
      ],
    ),
  );
}

class RiskItem extends StatelessWidget {
  final String title;
  final String projectName;
  final String subtitle;
  final String severity;
  final VoidCallback? onTap;

  const RiskItem({super.key, required this.title, required this.projectName,
    required this.subtitle, required this.severity, this.onTap,
  });

  Color severityColor() {
    switch (severity.toLowerCase()) {
      case 'high':
        return const Color(0xFFE74C3C);
      case 'medium':
        return const Color(0xFFF5A623);
      default:
        return AppTheme.primaryFgColor;
    }
  }

  IconData severityIcon() {
    switch (severity.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.report_problem_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = severityIcon();
    final color = severityColor();
    final trailingBg = Color.alphaBlend(Colors.white12, AppTheme.primaryCardColor);
    final trailingFg = Colors.white;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryCardColor,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(35),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.textStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      projectName,
                      style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(150)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTheme.textStyle(fontSize: 12, color: Colors.white.withAlpha(150)),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: trailingBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: trailingFg,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}