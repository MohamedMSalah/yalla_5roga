import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';
import 'package:yalla_5roga/features/profile/presentation/widgets/about_developer_card.dart';

class AboutDeveloperPage extends StatelessWidget {
  const AboutDeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: AppIconButton(icon: Icons.chevron_left, onTap: Get.back),
          title: Text(
            context.l10n.aboutDeveloper,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd),
          ),
        ),
        body: ListView(
          padding: Responsive.pagePadding(),
          children: const [AboutDeveloperCard()],
        ),
      ),
    );
  }
}
