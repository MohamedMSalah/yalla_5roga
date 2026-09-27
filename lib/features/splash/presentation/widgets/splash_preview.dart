import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_badge.dart';
import 'package:yalla_5roga/core/widgets/icon_circle.dart';

class SplashPreview extends StatelessWidget {
  const SplashPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 250.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 208.w,
            height: 208.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Transform.rotate(
            angle: 0.05,
            child: Container(
              width: 148.w,
              height: 148.w,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 24.w,
                    offset: Offset(0, 12.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      AppBadge(label: l10n.fridayPlan),
                      const Spacer(),
                      Icon(Icons.more_horiz, color: AppColors.slate400, size: 16.w),
                    ],
                  ),
                  const Spacer(),
                  const IconCircle(
                    icon: Icons.location_on_outlined,
                    background: AppColors.brand100,
                    foreground: AppColors.brand600,
                    size: 52,
                    radius: 16,
                  ),
                  const Spacer(),
                  Text(
                    l10n.zedParkPicnic,
                    style: TextStyle(
                      color: AppColors.slate900,
                      fontWeight: FontWeight.w800,
                      fontSize: Responsive.fontSm,
                    ),
                  ),
                  Text(
                    l10n.friendsAreIn,
                    style: TextStyle(color: AppColors.slate400, fontSize: Responsive.fontCaption),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18.w,
            top: 24.h,
            child: const IconCircle(
              icon: Icons.wb_sunny_outlined,
              background: Color(0xFFFCD34D),
              foreground: Color(0xFF78350F),
              size: 46,
            ),
          ),
          Positioned(
            right: 22.w,
            bottom: 36.h,
            child: const IconCircle(
              icon: Icons.groups_2_outlined,
              background: Color(0xFF6EE7B7),
              foreground: Color(0xFF064E3B),
              size: 46,
            ),
          ),
          Positioned(
            right: 12.w,
            top: 20.h,
            child: _pill(l10n.votedAll, Colors.white, AppColors.brand700),
          ),
          Positioned(
            left: 18.w,
            bottom: 8.h,
            child: _pill(l10n.seeYouThere, const Color(0xFF8B5CF6), Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color background, Color color) {
    return Container(
      padding: Responsive.padding(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12.w),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: Responsive.fontCaption, fontWeight: FontWeight.w800),
      ),
    );
  }
}
