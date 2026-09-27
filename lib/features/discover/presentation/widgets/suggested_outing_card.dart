import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/demo/discover_data.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_badge.dart';
import 'package:yalla_5roga/core/widgets/app_network_image.dart';

class SuggestedOutingCard extends StatelessWidget {
  const SuggestedOutingCard({
    super.key,
    required this.outing,
    required this.onTap,
    this.compact = false,
  });

  final SuggestedOuting outing;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final place = outing.place;
    final width = compact
        ? (Responsive.isMobile ? 210.w : 240.w)
        : (Responsive.isMobile ? 260.w : 300.w);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: compact ? 196.h : 236.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Responsive.radiusLg),
          child: Container(
            color: palette.surface,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Responsive.radiusLg),
              border: Border.all(color: palette.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppNetworkImage(url: outing.imageUrl),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xB30F172A)],
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: 10.w,
                        top: 10.h,
                        child: AppBadge(
                          label: l10n.vibeLabel(outing.vibe.name),
                          color: Colors.white.withValues(alpha: 0.92),
                          textColor: AppColors.brand700,
                        ),
                      ),
                      PositionedDirectional(
                        start: 10.w,
                        end: 10.w,
                        bottom: 10.h,
                        child: Text(
                          outing.title(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: compact ? Responsive.fontSm : Responsive.fontMd,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(compact ? 10.w : 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.outingAtPlace(
                          place.localizedName(l10n),
                          '${outing.formattedWeekday(l10n)} · ${outing.formattedTime(l10n)}',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: Responsive.fontCaption,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (!compact) ...[
                        Responsive.spaceXs.gapH,
                        Text(
                          outing.blurb(l10n),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: palette.textMuted,
                            fontSize: Responsive.fontSm,
                          ),
                        ),
                      ],
                      Responsive.spaceSm.gapH,
                      Text(
                        compact ? l10n.useThisIdea : l10n.planThisOuting,
                        style: TextStyle(
                          color: AppColors.brand600,
                          fontWeight: FontWeight.w800,
                          fontSize: Responsive.fontSm,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
