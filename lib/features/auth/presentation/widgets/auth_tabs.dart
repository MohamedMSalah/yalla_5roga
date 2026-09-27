import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/segmented_tabs.dart';

class AuthTabs extends StatelessWidget {
  const AuthTabs({
    super.key,
    required this.isLogin,
    required this.onChanged,
  });

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedTabs(
      labels: [l10n.login, l10n.register],
      index: isLogin ? 0 : 1,
      onChanged: (index) => onChanged(index == 0),
    );
  }
}
