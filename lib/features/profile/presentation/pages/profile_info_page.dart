import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';

class ProfileInfoPage extends StatelessWidget {
  const ProfileInfoPage({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: AppIconButton(icon: Icons.chevron_left, onTap: Get.back),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontMd)),
        ),
        body: ListView(
          padding: Responsive.pagePadding(),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) ...[
                      Divider(height: 24.h, color: context.palette.border),
                    ],
                    children[i],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoBlock extends StatelessWidget {
  const ProfileInfoBlock({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontBody)),
        Responsive.spaceSm.gapH,
        Text(
          body,
          style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontSm, height: 1.45),
        ),
      ],
    );
  }
}
