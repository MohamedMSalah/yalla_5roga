import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/localization/l10n.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_badge.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/app_network_image.dart';
import 'package:yalla_5roga/core/widgets/app_page_bar.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/utils/validators.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';
import 'package:yalla_5roga/core/widgets/image_source_sheet.dart';
import 'package:yalla_5roga/core/widgets/phone_text_field.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/create_outing_page.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/event_page.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/outings_provider.dart';
import 'package:yalla_5roga/features/outings/presentation/widgets/outing_list_tile.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.group});

  final DemoGroup group;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late DemoGroup _group;

  bool get _canManage => _group.myRole == GroupRole.owner || _group.myRole == GroupRole.admin;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
  }

  String _roleLabel(GroupRole role, L10n l10n) {
    return switch (role) {
      GroupRole.owner => l10n.owner,
      GroupRole.admin => l10n.admin,
      GroupRole.member => l10n.member,
    };
  }

  Future<void> _changeImage() async {
    if (!_canManage) return;
    final url = await ImageSourceSheet.pick(title: context.l10n.changeGroupImage);
    if (url == null || !mounted) return;
    setState(() => _group = _group.copyWith(image: url));
    AppSnackBar.show(context.l10n.groupImageUpdated);
  }

  Future<void> _addMember() async {
    final phoneController = TextEditingController();
    final added = await Get.bottomSheet<String>(
      SafeArea(
        child: Builder(
          builder: (context) {
            final l10n = context.l10n;
            final palette = context.palette;
            return Container(
              padding: Responsive.padding(all: 20),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.addByPhone, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
                  Responsive.spaceMd.gapH,
                  PhoneTextField(
                    controller: phoneController,
                    validate: false,
                  ),
                  Responsive.spaceMd.gapH,
                  CustomButton(
                    label: l10n.addPhone,
                    onPressed: () {
                      final error = Validators.phone(phoneController.text, l10n);
                      if (error != null) {
                        AppSnackBar.show(error);
                        return;
                      }
                      Get.back(result: Validators.normalizePhone(phoneController.text));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (added == null || !mounted) return;
    if (_group.people.any((person) => person.id == added || person.name == added)) {
      AppSnackBar.show(context.l10n.phoneAlreadyAdded);
      return;
    }
    setState(() {
      _group = _group.copyWith(
        people: [
          ..._group.people,
          DemoMember(id: added, name: added, avatar: DemoData.avatars[added.hashCode.abs() % DemoData.avatars.length]),
        ],
      );
    });
    AppSnackBar.show(context.l10n.memberAdded(added));
  }

  void _removeMember(DemoMember person) {
    if (person.role == GroupRole.owner) return;
    setState(() {
      _group = _group.copyWith(
        people: _group.people.where((item) => item.id != person.id).toList(),
      );
    });
    AppSnackBar.show(context.l10n.memberRemoved(person.name));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;
    final groupOutings = context.watch<OutingsProvider>().forGroup(_group.id);

    return Scaffold(
      appBar: AppPageBar(title: _group.name),
      body: ListView(
        padding: Responsive.pagePadding(),
        children: [
          GestureDetector(
            onTap: _canManage ? _changeImage : null,
            child: Stack(
              children: [
                AppNetworkImage(url: _group.image, width: double.infinity, height: 180.h, radius: 22.r),
                if (_canManage)
                  Positioned(
                    right: 12.w,
                    bottom: 12.h,
                    child: CircleAvatar(
                      backgroundColor: AppColors.brand600,
                      child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18.w),
                    ),
                  ),
              ],
            ),
          ),
          Responsive.spaceMd.gapH,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_group.name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontLg)),
                    Text(
                      l10n.membersOutings(_group.people.length, groupOutings.length),
                      style: TextStyle(color: palette.textMuted, fontSize: Responsive.fontSm),
                    ),
                  ],
                ),
              ),
              AppBadge(
                label: _roleLabel(_group.myRole, l10n),
                color: AppColors.brand50,
                textColor: AppColors.brand700,
              ),
            ],
          ),
          Responsive.spaceMd.gapH,
          CustomButton(
            label: l10n.createOuting,
            icon: Icons.add,
            onPressed: () => Get.to(() => CreateOutingPage(group: _group)),
          ),
          if (_canManage) ...[
            Responsive.spaceSm.gapH,
            CustomButton(
              label: l10n.addPeople,
              icon: Icons.person_add_alt_1_outlined,
              variant: AppButtonVariant.outlined,
              onPressed: _addMember,
            ),
          ],
          Responsive.spaceLg.gapH,
          Text(l10n.groupOutings, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
          Responsive.spaceSm.gapH,
          if (groupOutings.isEmpty)
            Text(l10n.noGroupOutings, style: TextStyle(color: palette.textMuted, fontSize: Responsive.fontSm))
          else
            for (final outing in groupOutings) ...[
              OutingListTile(
                title: outing.title,
                subtitle: '${outing.date} · ${outing.time} · ${outing.meta}',
                image: outing.image,
                onTap: () => Get.to(() => EventPage(event: outing)),
              ),
              8.gapH,
            ],
          Responsive.spaceLg.gapH,
          Text(l10n.members, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
          Responsive.spaceSm.gapH,
          for (final person in _group.people) ...[
            AppCard(
              radius: 16,
              child: Row(
                children: [
                  AppNetworkImage(url: person.avatar, width: 44.w, height: 44.w, radius: 12.r),
                  12.gapW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontBody)),
                        Text(_roleLabel(person.role, l10n), style: TextStyle(color: palette.textMuted, fontSize: 10.sp)),
                      ],
                    ),
                  ),
                  if (_canManage && person.role != GroupRole.owner)
                    IconButton(
                      onPressed: () => _removeMember(person),
                      icon: Icon(Icons.remove_circle_outline, color: AppColors.rose500, size: 20.w),
                    ),
                ],
              ),
            ),
            8.gapH,
          ],
        ],
      ),
    );
  }
}
