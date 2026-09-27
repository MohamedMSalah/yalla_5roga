import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/demo/demo_data.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/utils/validators.dart';
import 'package:yalla_5roga/core/widgets/app_network_image.dart';
import 'package:yalla_5roga/core/widgets/app_page_bar.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';
import 'package:yalla_5roga/core/widgets/custom_textfield.dart';
import 'package:yalla_5roga/core/widgets/image_source_sheet.dart';
import 'package:yalla_5roga/core/widgets/phone_text_field.dart';
import 'package:yalla_5roga/features/groups/presentation/pages/group_page.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _image;
  final _phones = <String>[];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final path = await ImageSourceSheet.pick(title: context.l10n.changeGroupImage);
    if (path == null || !mounted) return;
    setState(() => _image = path);
  }

  void _addPhone() {
    final l10n = context.l10n;
    final error = Validators.phone(_phoneController.text, l10n);
    if (error != null) {
      AppSnackBar.show(error);
      return;
    }
    final phone = Validators.normalizePhone(_phoneController.text);
    if (_phones.contains(phone)) {
      AppSnackBar.show(l10n.phoneAlreadyAdded);
      return;
    }
    setState(() {
      _phones.add(phone);
      _phoneController.clear();
    });
  }

  void _create() {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      AppSnackBar.show(context.l10n.uploadPhoto);
      return;
    }
    final people = [
      const DemoMember(
        id: 'ahmed',
        name: 'Ahmed',
        avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=120&q=80',
        role: GroupRole.owner,
      ),
      for (final phone in _phones)
        DemoMember(
          id: phone,
          name: phone,
          avatar: DemoData.avatars[phone.hashCode.abs() % DemoData.avatars.length],
        ),
    ];
    final group = DemoGroup(
      id: 'new-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      members: people.length,
      outings: 0,
      preview: '',
      avatars: people.map((person) => person.avatar).toList(),
      image: _image!,
      people: people,
      myRole: GroupRole.owner,
    );
    AppSnackBar.show(context.l10n.groupCreated);
    Get.off(() => GroupPage(group: group));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = context.palette;

    return Scaffold(
      appBar: AppPageBar(
        title: l10n.createGroup,
        backIcon: Icons.close,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: Responsive.pagePadding(),
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image == null
                          ? Container(
                              height: 160.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: palette.surfaceMuted,
                                borderRadius: BorderRadius.circular(22.r),
                                border: Border.all(color: palette.border),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_outlined, color: AppColors.brand600, size: 28.w),
                                  8.gapH,
                                  Text(l10n.uploadPhoto, style: TextStyle(color: AppColors.brand600, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                AppNetworkImage(url: _image!, width: double.infinity, height: 160.h, radius: 22.r),
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
                    Responsive.spaceLg.gapH,
                    CustomTextField(
                      controller: _nameController,
                      label: l10n.groupName,
                      hint: l10n.groupNameHint,
                      prefixIcon: Icons.groups_2_outlined,
                      validator: (value) => Validators.required(value, l10n),
                    ),
                    Responsive.spaceLg.gapH,
                    Text(
                      l10n.addByPhone,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: Responsive.fontSm,
                        color: palette.textSecondary,
                      ),
                    ),
                    Responsive.spaceSm.gapH,
                    PhoneTextField(
                      controller: _phoneController,
                      validate: false,
                    ),
                    Responsive.spaceSm.gapH,
                    CustomButton(
                      label: l10n.addPhone,
                      icon: Icons.person_add_alt_1_outlined,
                      size: AppButtonSize.medium,
                      variant: AppButtonVariant.outlined,
                      onPressed: _addPhone,
                    ),
                    if (_phones.isNotEmpty) ...[
                      Responsive.spaceMd.gapH,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          for (final phone in _phones)
                            Chip(
                              label: Text(phone, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.sp)),
                              onDeleted: () => setState(() => _phones.remove(phone)),
                              backgroundColor: palette.surfaceMuted,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: Responsive.padding(horizontal: 20, top: 8, bottom: 12),
              child: CustomButton(
                label: l10n.createGroup,
                icon: Icons.check,
                onPressed: _create,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
