import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/filter_chip_row.dart';
import 'package:yalla_5roga/core/widgets/section_header.dart';
import 'package:yalla_5roga/features/groups/presentation/pages/create_group_page.dart';
import 'package:yalla_5roga/features/groups/presentation/pages/group_page.dart';
import 'package:yalla_5roga/features/groups/presentation/widgets/create_group_card.dart';
import 'package:yalla_5roga/features/groups/presentation/widgets/featured_group_card.dart';
import 'package:yalla_5roga/features/groups/presentation/widgets/group_card.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final groups = DemoData.groups.where((group) {
      if (_filter == 1) return group.featured || group.unread > 0;
      return true;
    }).toList();

    return SafeArea(
      child: ListView(
        padding: Responsive.pagePadding(),
        children: [
          SectionHeader(
            eyebrow: l10n.yourCircles,
            title: l10n.groupsTitle,
            subtitle: l10n.activeGroupsFriends,
          ),
          Responsive.spaceSm.gapH,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppIconButton(icon: Icons.search, onTap: () => AppSnackBar.show(l10n.search)),
              Responsive.spaceSm.gapW,
              AppIconButton(
                icon: Icons.add,
                background: AppColors.brand600,
                foreground: Colors.white,
                onTap: () => Get.to(() => const CreateGroupPage()),
              ),
            ],
          ),
          Responsive.spaceMd.gapH,
          FilterChipRow(
            labels: [l10n.allGroups, l10n.mostActive, l10n.recentlyAdded],
            index: _filter,
            onChanged: (index) => setState(() => _filter = index),
          ),
          Responsive.spaceMd.gapH,
          ListCard(
            children: [
              for (final group in groups)
                group.featured
                    ? FeaturedGroupCard(
                        group: group,
                        onTap: () => Get.to(() => GroupPage(group: group)),
                      )
                    : GroupCard(
                        group: group,
                        onTap: () => Get.to(() => GroupPage(group: group)),
                      ),
              CreateGroupCard(onTap: () => Get.to(() => const CreateGroupPage())),
            ],
          ),
        ],
      ),
    );
  }
}
