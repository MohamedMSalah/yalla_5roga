import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/event_page.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_badge.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/icon_circle.dart';

class VoteOption {
  const VoteOption(this.label, this.votes, this.percent);

  final String label;
  final int votes;
  final int percent;
}

class VoteCard extends StatefulWidget {
  const VoteCard({super.key});

  @override
  State<VoteCard> createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  int _selected = 0;
  final options = const [
    VoteOption('The Brunch Room', 3, 60),
    VoteOption("Lucille's", 2, 40),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      onTap: () => Get.to(() => EventPage(event: DemoData.slideById('weekend-brunch'))),
      child: Column(
        children: [
          Row(
            children: [
              const IconCircle(
                icon: Icons.restaurant,
                background: AppColors.amber100,
                foreground: AppColors.amber700,
              ),
              12.gapW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.fridayBrunchCrew, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.sp)),
                    Text(l10n.pickFavoritePlace, style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp)),
                  ],
                ),
              ),
              AppBadge(label: '5/8', color: AppColors.brand50, textColor: AppColors.brand600),
            ],
          ),
          12.gapH,
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) Responsive.spaceSm.gapH,
            GestureDetector(
              onTap: () {
                setState(() => _selected = i);
                AppSnackBar.show(l10n.voteUpdated);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: i == _selected ? context.palette.brandSoft : context.palette.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: i == _selected ? AppColors.brand500 : context.palette.border,
                    width: i == _selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _selected ? AppColors.brand600 : Colors.transparent,
                        border: Border.all(color: i == _selected ? AppColors.brand600 : context.palette.border, width: 2),
                      ),
                      child: i == _selected ? Icon(Icons.check, size: 12.w, color: Colors.white) : null,
                    ),
                    Responsive.spaceSm.gapW,
                    Expanded(
                      child: Text(options[i].label, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontSm)),
                    ),
                    Text(
                      l10n.votesPercent(options[i].votes, options[i].percent),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: i == _selected ? AppColors.brand600 : context.palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
