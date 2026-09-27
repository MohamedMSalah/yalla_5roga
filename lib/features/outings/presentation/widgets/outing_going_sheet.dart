import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/localization/l10n.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_network_image.dart';

class OutingGoingSheet {
  const OutingGoingSheet._();

  static Future<void> show(HeroSlide event) {
    return Get.bottomSheet(
      SafeArea(
        child: Builder(
          builder: (context) {
            final l10n = context.l10n;
            final palette = context.palette;
            final members = _members(event);
            final place = event.location?.name ?? event.meta.split('·').first.trim();

            return Container(
              height: Responsive.height * 0.55,
              padding: Responsive.padding(all: 20),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.whoIsGoing, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
                  Text(l10n.goingCount(members.length), style: TextStyle(color: palette.textMuted, fontSize: Responsive.fontSm)),
                  Responsive.spaceMd.gapH,
                  Expanded(
                    child: ListView.separated(
                      itemCount: members.length,
                      separatorBuilder: (_, _) => 8.gapH,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return Row(
                          children: [
                            AppNetworkImage(url: member.avatar, width: 44.w, height: 44.w, radius: 12.r),
                            12.gapW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(member.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                                  Text(
                                    _voteLabel(index, place, l10n),
                                    style: TextStyle(color: palette.textMuted, fontSize: 10.sp),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              index % 3 == 2 ? Icons.hourglass_empty : Icons.how_to_vote_outlined,
                              color: index % 3 == 2 ? palette.textMuted : AppColors.brand600,
                              size: 18.w,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      isScrollControlled: true,
    );
  }

  static List<DemoMember> _members(HeroSlide event) {
    if (event.guestIds.isNotEmpty) {
      return [
        for (final id in event.guestIds)
          if (DemoData.memberById(id) != null) DemoData.memberById(id)!,
      ];
    }
    final group = event.groupId == null
        ? null
        : DemoData.groups.cast<DemoGroup?>().firstWhere(
              (item) => item?.id == event.groupId,
              orElse: () => null,
            );
    final pool = <DemoMember>[...?group?.people];
    for (final person in DemoData.people) {
      if (pool.every((item) => item.id != person.id)) pool.add(person);
    }
    if (pool.isEmpty) return const [];
    return [for (var i = 0; i < event.going; i++) pool[i % pool.length]];
  }

  static String _voteLabel(int index, String place, L10n l10n) {
    return switch (index % 3) {
      0 => l10n.votedFor(place),
      1 => l10n.votedGoing,
      _ => l10n.notVotedYet,
    };
  }
}
