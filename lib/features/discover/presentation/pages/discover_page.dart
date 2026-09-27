import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/demo/discover_data.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_page_bar.dart';
import 'package:yalla_5roga/core/widgets/filter_chip_row.dart';
import 'package:yalla_5roga/core/widgets/section_header.dart';
import 'package:yalla_5roga/features/discover/presentation/widgets/suggested_outing_card.dart';
import 'package:yalla_5roga/features/discover/presentation/widgets/suggested_place_tile.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/create_outing_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int _filter = 0;

  OutingVibe? get _vibe => switch (_filter) {
        1 => OutingVibe.food,
        2 => OutingVibe.activity,
        3 => OutingVibe.outdoor,
        4 => OutingVibe.movie,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outings = DiscoverData.outingsFor(_vibe);
    final places = DiscoverData.placesFor(_vibe);

    return Scaffold(
      appBar: AppPageBar(title: l10n.discover),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: Responsive.pagePadding(),
          children: [
            SectionHeader(
              eyebrow: l10n.tryThis,
              title: l10n.suggestedForYou,
              subtitle: l10n.discoverSubtitle,
            ),
            Responsive.spaceMd.gapH,
            FilterChipRow(
              labels: [l10n.allVibes, l10n.food, l10n.activity, l10n.outdoor, l10n.movie],
              index: _filter,
              onChanged: (index) => setState(() => _filter = index),
            ),
            Responsive.spaceLg.gapH,
            Text(
              l10n.tryThis.toUpperCase(),
              style: TextStyle(
                color: context.palette.textMuted,
                fontSize: Responsive.fontCaption,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
              ),
            ),
            Responsive.spaceSm.gapH,
            SizedBox(
              height: 236.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: outings.length,
                separatorBuilder: (_, _) => Responsive.spaceSm.gapW,
                itemBuilder: (context, index) {
                  final outing = outings[index];
                  return SuggestedOutingCard(
                    outing: outing,
                    onTap: () => Get.to(() => CreateOutingPage(suggestion: outing)),
                  );
                },
              ),
            ),
            Responsive.spaceLg.gapH,
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
            for (final place in places) ...[
              SuggestedPlaceTile(
                place: place,
                onTap: () => Get.to(() => CreateOutingPage(suggestedPlace: place)),
              ),
              Responsive.spaceSm.gapH,
            ],
          ],
        ),
      ),
    );
  }
}
