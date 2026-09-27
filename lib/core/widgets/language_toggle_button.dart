import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/localization/locale_provider.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({
    super.key,
    this.onBrand = false,
  });

  /// Splash-style chip on the indigo brand background.
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.watch<LocaleProvider>();
    final palette = context.palette;

    return GestureDetector(
      onTap: () async {
        await locale.toggle();
        AppSnackBar.show(l10n.languageChanged);
      },
      child: Container(
        padding: Responsive.padding(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: onBrand ? Colors.white.withValues(alpha: 0.15) : palette.surface,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: onBrand ? Colors.white.withValues(alpha: 0.2) : palette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.translate,
              color: onBrand ? Colors.white : palette.brand,
              size: Responsive.iconSm,
            ),
            6.gapW,
            Text(
              locale.isRtl ? l10n.english : l10n.arabic,
              style: TextStyle(
                color: onBrand ? Colors.white : palette.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
