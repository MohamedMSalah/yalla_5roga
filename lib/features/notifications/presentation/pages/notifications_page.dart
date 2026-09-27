import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/segmented_tabs.dart';
import 'package:yalla_5roga/features/groups/presentation/pages/group_page.dart';
import 'package:yalla_5roga/features/notifications/presentation/providers/notifications_provider.dart';
import 'package:yalla_5roga/features/notifications/presentation/widgets/notification_card.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/event_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _filter = 0;

  void _open(DemoNotificationItem item) {
    context.read<NotificationsProvider>().markRead(item.id);
    if (item.eventId != null) {
      Get.to(() => EventPage(event: DemoData.slideById(item.eventId!)));
      return;
    }
    if (item.groupId != null) {
      Get.to(() => GroupPage(group: DemoData.groupById(item.groupId!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final notifications = context.watch<NotificationsProvider>();
    final unreadCount = notifications.unreadCount;
    final items = _filter == 0
        ? notifications.items
        : notifications.items.where((item) => item.unread).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: Responsive.pagePadding(),
          children: [
            Row(
              children: [
                AppIconButton(icon: Icons.chevron_left, onTap: Get.back),
                Expanded(
                  child: Column(
                    children: [
                      Text(l10n.notifications, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
                      Text(l10n.unreadUpdates(unreadCount), style: TextStyle(color: context.palette.textMuted, fontSize: 10.sp)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: unreadCount == 0
                      ? null
                      : () {
                          notifications.markAllRead();
                          AppSnackBar.show(l10n.allNotificationsRead);
                        },
                  child: Text(
                    unreadCount == 0 ? l10n.allRead : l10n.markAllRead,
                    style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800, fontSize: Responsive.fontSm),
                  ),
                ),
              ],
            ),
            Responsive.spaceMd.gapH,
            SegmentedTabs(
              labels: [l10n.all, l10n.unread],
              index: _filter,
              onChanged: (index) => setState(() => _filter = index),
              badges: {1: '$unreadCount'},
            ),
            Responsive.spaceLg.gapH,
            Text(l10n.today.toUpperCase(), style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontCaption, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            Responsive.spaceSm.gapH,
            ListCard(
              children: [
                for (final item in items.take(3))
                  NotificationCard(
                    body: item.body,
                    time: item.time,
                    unread: item.unread,
                    image: item.image,
                    actionLabel: item.action ? l10n.voteNow : null,
                    onAction: () => _open(item),
                    onTap: () => _open(item),
                  ),
              ],
            ),
            Responsive.spaceLg.gapH,
            Text(l10n.earlier.toUpperCase(), style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontCaption, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
            Responsive.spaceSm.gapH,
            ListCard(
              children: [
                for (final item in items.skip(3))
                  NotificationCard(
                    body: item.body,
                    time: item.time,
                    unread: item.unread,
                    image: item.image,
                    onTap: () => _open(item),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
