import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_bottom_nav.dart';
import 'package:yalla_5roga/core/widgets/app_bottom_nav_layout.dart';
import 'package:yalla_5roga/features/groups/presentation/pages/groups_page.dart';
import 'package:yalla_5roga/features/home/presentation/pages/home_page.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/outings_page.dart';
import 'package:yalla_5roga/features/profile/presentation/pages/settings_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppBottomNavLayout(
      currentIndex: _index,
      onChanged: (index) => setState(() => _index = index),
      pages: [
        HomePage(onSeeAllOutings: () => setState(() => _index = 2)),
        const GroupsPage(),
        const OutingsPage(),
        const SettingsPage(),
      ],
      items: [
        AppBottomNavItem(icon: Icons.home_rounded, label: l10n.navHome),
        AppBottomNavItem(icon: Icons.groups_2_rounded, label: l10n.navGroups),
        AppBottomNavItem(icon: Icons.explore_outlined, label: l10n.navOutings),
        AppBottomNavItem(icon: Icons.settings_outlined, label: l10n.navSettings),
      ],
    );
  }
}
