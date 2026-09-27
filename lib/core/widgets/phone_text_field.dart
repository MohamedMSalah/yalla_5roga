import 'package:flutter/material.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/utils/input_formatters.dart';
import 'package:yalla_5roga/core/utils/validators.dart';
import 'package:yalla_5roga/core/widgets/custom_textfield.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.validator,
    this.validate = true,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool validate;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CustomTextField(
      controller: controller,
      label: label ?? l10n.phone,
      hint: hint ?? l10n.phoneHint,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      prefix: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_outlined, size: 18.w, color: AppColors.brand600),
            6.gapW,
            Text('+20', style: TextStyle(fontWeight: FontWeight.w800, fontSize: Responsive.fontBody)),
          ],
        ),
      ),
      inputFormatters: [InputFormatters.digitsOnly, InputFormatters.maxLength(11)],
      validator: validator ?? (validate ? (value) => Validators.phone(value, l10n) : null),
    );
  }
}
