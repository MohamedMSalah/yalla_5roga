import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_card.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      radius: 20,
      child: Row(
        children: [
          _stat(context, '24', l10n.outingsStat),
          Container(width: 1.w, height: 36.h, color: context.palette.border),
          _stat(context, '3', l10n.groupsStat),
          Container(width: 1.w, height: 36.h, color: context.palette.border),
          _stat(context, '86%', l10n.showUp),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: context.palette.textMuted,
              fontSize: Responsive.fontXs,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
