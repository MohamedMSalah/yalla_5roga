import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_badge.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/icon_circle.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.background,
    required this.foreground,
    this.badge,
    this.progress,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color background;
  final Color foreground;
  final String? badge;
  final double? progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      radius: 18,
      child: Row(
        children: [
          IconCircle(icon: icon, background: background, foreground: foreground),
          12.gapW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.sp),
                      ),
                    ),
                    if (badge != null) AppBadge(label: badge!),
                  ],
                ),
                Responsive.spaceXs.gapH,
                Text(subtitle, style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontSm)),
                if (progress != null) ...[
                  Responsive.spaceSm.gapH,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6.h,
                      color: AppColors.brand500,
                      backgroundColor: context.palette.surfaceMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (progress == null)
            Icon(Icons.chevron_right, color: context.palette.border, size: 20.w),
        ],
      ),
    );
  }
}
