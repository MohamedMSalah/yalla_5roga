import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.badges = const {},
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final Map<int, String> badges;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: i == index ? palette.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: i == index
                        ? [
                            BoxShadow(
                              color: palette.shadow,
                              blurRadius: 8.w,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: Responsive.fontSm,
                          fontWeight: FontWeight.w800,
                          color: i == index ? palette.brandStrong : palette.textMuted,
                        ),
                      ),
                      if (badges[i] != null) ...[
                        Responsive.spaceXs.gapW,
                        Container(
                          padding: Responsive.padding(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: i == index ? AppColors.brand100 : AppColors.rose500,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            badges[i]!,
                            style: TextStyle(
                              fontSize: Responsive.fontXs,
                              fontWeight: FontWeight.w800,
                              color: i == index ? AppColors.brand700 : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
