import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';
import 'package:yalla_5roga/core/widgets/app_page_bar.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/segmented_tabs.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/create_outing_page.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/saved_outings_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/widgets/outing_list_tile.dart';

class SavedOutingsPage extends StatefulWidget {
  const SavedOutingsPage({super.key});

  @override
  State<SavedOutingsPage> createState() => _SavedOutingsPageState();
}

class _SavedOutingsPageState extends State<SavedOutingsPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = context.watch<SavedOutingsProvider>();
    final saved = store.saved;
    final drafts = store.drafts;
    final items = _tab == 0 ? saved : drafts;

    return Scaffold(
      appBar: AppPageBar(title: l10n.mySaved, subtitle: l10n.mySavedSubtitle),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: Responsive.padding(horizontal: 20, top: 8),
              child: SegmentedTabs(
                labels: [l10n.mySaved, l10n.drafts],
                index: _tab,
                onChanged: (index) => setState(() => _tab = index),
                badges: {
                  0: '${saved.length}',
                  1: '${drafts.length}',
                },
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: Responsive.pagePadding(),
                        child: Text(
                          _tab == 0 ? l10n.noSavedOutings : l10n.noDrafts,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontBody),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: Responsive.pagePadding(),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => 8.gapH,
                      itemBuilder: (context, index) {
                        if (_tab == 0) {
                          final outing = saved[index];
                          return OutingListTile(
                            title: outing.title,
                            subtitle: outing.location.label,
                            image: outing.image,
                            onTap: () => Get.to(() => CreateOutingPage(saved: outing)),
                            trailing: AppIconButton(
                              icon: Icons.delete_outline,
                              size: 32,
                              foreground: AppColors.rose500,
                              onTap: () async {
                                await store.removeSaved(outing.id);
                                AppSnackBar.show(l10n.outingRemoved);
                              },
                            ),
                          );
                        }
                        final draft = drafts[index];
                        return OutingListTile(
                          title: draft.title,
                          subtitle: draft.location.label,
                          image: draft.image,
                          onTap: () => Get.to(() => CreateOutingPage(draft: draft, specialEvent: draft.specialEvent)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
