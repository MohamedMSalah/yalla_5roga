import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/constants/app_constants.dart';
import 'package:yalla_5roga/core/localization/l10n.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/features/discover/presentation/pages/discover_page.dart';
import 'package:yalla_5roga/features/groups/presentation/pages/create_group_page.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/create_outing_page.dart';
import 'package:yalla_5roga/core/utils/app_launcher.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/icon_circle.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final actions = [
      _Action(l10n.newOuting, Icons.add, AppColors.brand600, Colors.white, context.palette.brandSoft, () {
        Get.to(() => const CreateOutingPage());
      }, highlighted: true),
      _Action(l10n.specialEvent, Icons.celebration_outlined, const Color(0xFFDB2777), const Color(0xFFFCE7F3), context.palette.surface, () {
        Get.to(() => const CreateOutingPage(specialEvent: true));
      }),
      _Action(l10n.newGroup, Icons.groups_2_outlined, const Color(0xFF7C3AED), const Color(0xFFEDE9FE), context.palette.surface, () {
        Get.to(() => const CreateGroupPage());
      }),
      _Action(l10n.discover, Icons.explore_outlined, const Color(0xFFD97706), const Color(0xFFFEF3C7), context.palette.surface, () {
        Get.to(() => const DiscoverPage());
      }),
      _Action(l10n.invite, Icons.person_add_alt_1_outlined, const Color(0xFF059669), const Color(0xFFD1FAE5), context.palette.surface, () {
        _shareInvite(context, l10n);
      }),
    ];

    return Column(
      children: [
        Row(
          children: [
            for (final action in actions.take(3))
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: _ActionTile(action: action),
                ),
              ),
          ],
        ),
        8.gapH,
        Row(
          children: [
            for (final action in actions.skip(3))
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: _ActionTile(action: action),
                ),
              ),
          ],
        ),
      ],
    );
  }

  static Future<void> _shareInvite(BuildContext context, L10n l10n) async {
    final opened = await AppLauncher.shareOnWhatsApp(
      l10n.inviteDownloadMessage(AppConstants.downloadUrl),
    );
    if (!opened && context.mounted) {
      AppSnackBar.show(l10n.couldNotOpenWhatsApp);
    }
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});

  final _Action action;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: action.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: action.highlighted ? context.palette.brandSoftBorder : context.palette.border,
          ),
        ),
        child: Column(
          children: [
            IconCircle(
              icon: action.icon,
              size: 36,
              radius: 12,
              background: action.highlighted ? action.foreground : action.background,
              foreground: action.highlighted ? Colors.white : action.foreground,
            ),
            Responsive.spaceSm.gapH,
            Text(
              action.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Responsive.fontCaption,
                fontWeight: FontWeight.w800,
                color: action.highlighted ? context.palette.brandStrong : context.palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Action {
  const _Action(
    this.label,
    this.icon,
    this.foreground,
    this.background,
    this.cardColor,
    this.onTap, {
    this.highlighted = false,
  });

  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color cardColor;
  final VoidCallback onTap;
  final bool highlighted;
}
