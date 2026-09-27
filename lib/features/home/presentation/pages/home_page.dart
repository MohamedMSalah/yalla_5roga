import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/section_header.dart';
import 'package:yalla_5roga/features/home/presentation/widgets/featured_outing_card.dart';
import 'package:yalla_5roga/features/home/presentation/widgets/home_header.dart';
import 'package:yalla_5roga/features/discover/presentation/widgets/discover_section.dart';
import 'package:yalla_5roga/features/home/presentation/widgets/quick_actions.dart';
import 'package:yalla_5roga/features/outings/presentation/widgets/outing_items.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.onSeeAllOutings});

  final VoidCallback? onSeeAllOutings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: ListView(
        padding: Responsive.pagePadding(),
        children: [
          const HomeHeader(),
          Responsive.spaceMd.gapH,
          const FeaturedOutingCard(),
          Responsive.spaceLg.gapH,
          SectionHeader(title: l10n.quickActions, subtitle: l10n.makeItHappen),
          12.gapH,
          const QuickActions(),
          Responsive.spaceLg.gapH,
          const DiscoverSection(showPlaces: true),
          Responsive.spaceLg.gapH,
          SectionHeader(
            title: l10n.happeningNow,
            actionLabel: l10n.seeAll,
            onAction: onSeeAllOutings,
          ),
          12.gapH,
          const OutingItems(limit: 3),
        ],
      ),
    );
  }
}
