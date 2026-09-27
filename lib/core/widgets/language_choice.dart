import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/localization/locale_provider.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';

class LanguageChoice extends StatelessWidget {
  const LanguageChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.watch<LocaleProvider>();
    final palette = context.palette;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: palette.surfaceSoft,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Chip(
            label: l10n.english,
            selected: !locale.isRtl,
            onTap: () => _select(context, const Locale('en')),
          ),
          _Chip(
            label: l10n.arabic,
            selected: locale.isRtl,
            onTap: () => _select(context, const Locale('ar')),
          ),
        ],
      ),
    );
  }

  Future<void> _select(BuildContext context, Locale next) async {
    final locale = context.read<LocaleProvider>();
    if (locale.locale == next) return;
    await locale.setLocale(next);
    AppSnackBar.show(context.l10n.languageChanged);
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: Responsive.padding(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.brand600 : Colors.transparent,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : context.palette.textMuted,
          ),
        ),
      ),
    );
  }
}
