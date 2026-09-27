import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/demo/discover_data.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/section_header.dart';
import 'package:yalla_5roga/features/discover/presentation/pages/discover_page.dart';
import 'package:yalla_5roga/features/discover/presentation/widgets/suggested_outing_card.dart';
import 'package:yalla_5roga/features/discover/presentation/widgets/suggested_place_tile.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/create_outing_page.dart';

class DiscoverSection extends StatelessWidget {
  const DiscoverSection({
    super.key,
    this.compact = true,
    this.limit = 5,
    this.showPlaces = false,
  });

  final bool compact;
  final int limit;
  final bool showPlaces;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outings = DiscoverData.featuredOutings().take(limit).toList();
    if (outings.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.discover,
          subtitle: l10n.exploreNearby,
          actionLabel: l10n.seeAll,
          onAction: () => Get.to(() => const DiscoverPage()),
        ),
        12.gapH,
        SizedBox(
          height: compact ? 196.h : 236.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: outings.length,
            separatorBuilder: (_, _) => Responsive.spaceSm.gapW,
            itemBuilder: (context, index) {
              final outing = outings[index];
              return SuggestedOutingCard(
                outing: outing,
                compact: compact,
                onTap: () => Get.to(() => CreateOutingPage(suggestion: outing)),
              );
            },
          ),
        ),
        if (showPlaces) ...[
          Responsive.spaceMd.gapH,
          Text(
            l10n.nearbyPlaces.toUpperCase(),
            style: TextStyle(
              color: context.palette.textMuted,
              fontSize: Responsive.fontCaption,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          Responsive.spaceSm.gapH,
          for (final place in DiscoverData.places.take(3)) ...[
            SuggestedPlaceTile(
              place: place,
              onTap: () => Get.to(() => CreateOutingPage(suggestedPlace: place)),
            ),
            Responsive.spaceSm.gapH,
          ],
        ],
      ],
    );
  }
}
