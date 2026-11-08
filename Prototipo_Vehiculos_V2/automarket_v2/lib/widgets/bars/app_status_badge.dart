import 'package:flutter/material.dart';

enum AppBadgeVariant {
  info,
  success,
  danger,
  purple,
  warning,
  neutral,
}

class AppStatusBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final AppBadgeVariant variant;
  final VoidCallback? onTap;

  const AppStatusBadge({
    Key? key,
    required this.label,
    this.icon,
    this.variant = AppBadgeVariant.info,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;

    switch (variant) {
      case AppBadgeVariant.info:
        bg = Colors.blue.shade50;
        border = Colors.blue.shade200;
        text = Colors.blue.shade800;
        break;
      case AppBadgeVariant.success:
        bg = Colors.green.shade50;
        border = Colors.green.shade200;
        text = Colors.green.shade700;
        break;
      case AppBadgeVariant.danger:
        bg = Colors.red.shade50;
        border = Colors.red.shade200;
        text = Colors.red.shade700;
        break;
      case AppBadgeVariant.purple:
        bg = Colors.purple.shade50;
        border = Colors.purple.shade200;
        text = Colors.purple.shade800;
        break;
      case AppBadgeVariant.warning:
        bg = Colors.amber.shade50;
        border = Colors.amber.shade300;
        text = Colors.amber.shade900;
        break;
      case AppBadgeVariant.neutral:
        bg = Colors.grey.shade100;
        border = Colors.grey.shade300;
        text = Colors.grey.shade800;
        break;
    }

    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: text),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: content,
      );
    }

    return content;
  }
}
