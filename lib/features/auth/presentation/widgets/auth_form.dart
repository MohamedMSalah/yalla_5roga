import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/features/shell/presentation/pages/main_shell.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/utils/validators.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';
import 'package:yalla_5roga/core/widgets/custom_textfield.dart';
import 'package:yalla_5roga/core/widgets/otp_input.dart';
import 'package:yalla_5roga/core/widgets/phone_text_field.dart';
import 'package:yalla_5roga/features/auth/presentation/providers/auth_provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, required this.isLogin});

  final bool isLogin;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOtp = false;
  bool _agreeTerms = true;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final valid = Validators.isValidEgyptianPhone(_phoneController.text);
    if (valid == _showOtp) return;

    setState(() {
      _showOtp = valid;
      if (!valid) _otpController.clear();
    });

    if (valid && mounted) {
      final phone = Validators.normalizePhone(_phoneController.text);
      AppSnackBar.show(context.l10n.otpSent(phone));
    }
  }

  void _resendOtp() {
    if (!_showOtp) return;
    final phone = Validators.normalizePhone(_phoneController.text);
    AppSnackBar.show(context.l10n.otpSent(phone));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = context.l10n;
    if (!widget.isLogin && !_agreeTerms) {
      AppSnackBar.show(l10n.termsRequired);
      return;
    }

    final auth = context.read<AuthProvider>();
    final phone = Validators.normalizePhone(_phoneController.text);
    final otp = _otpController.text.trim();
    final success = widget.isLogin
        ? await auth.login(phone: phone, password: otp)
        : await auth.register(
            name: _nameController.text.trim(),
            phone: phone,
            password: otp,
          );

    if (!mounted) return;
    if (!success) {
      AppSnackBar.show(auth.errorMessage ?? (widget.isLogin ? l10n.loginFailed : l10n.registerFailed));
      return;
    }

    AppSnackBar.show(
      widget.isLogin
          ? l10n.welcomeBackName(auth.user?.name ?? '')
          : l10n.accountCreated,
    );
    Get.offAll(() => const MainShell());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.isLogin) ...[
            CustomTextField(
              controller: _nameController,
              label: l10n.name,
              hint: l10n.nameHint,
              prefixIcon: Icons.person_outline,
              validator: (value) => Validators.required(value, l10n),
            ),
            Responsive.spaceMd.gapH,
          ],
          PhoneTextField(controller: _phoneController),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _showOtp
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Responsive.spaceMd.gapH,
                      OtpInput(
                        controller: _otpController,
                        label: l10n.otp,
                        validator: (value) => Validators.otp(value, l10n),
                        onCompleted: (_) => _submit(),
                        action: TextButton(
                          onPressed: _resendOtp,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            l10n.resendOtp,
                            style: TextStyle(
                              color: AppColors.brand600,
                              fontSize: Responsive.fontSm,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
          if (!widget.isLogin) ...[
            Responsive.spaceSm.gapH,
            Row(
              children: [
                Checkbox(
                  value: _agreeTerms,
                  activeColor: AppColors.brand600,
                  onChanged: (value) => setState(() => _agreeTerms = value ?? false),
                ),
                Expanded(
                  child: Text(
                    l10n.agreeTerms,
                    style: TextStyle(color: context.palette.textMuted, fontSize: Responsive.fontSm),
                  ),
                ),
              ],
            ),
          ],
          Responsive.spaceMd.gapH,
          CustomButton(
            label: widget.isLogin ? l10n.login : l10n.createAccount,
            icon: Icons.arrow_forward,
            isLoading: isLoading,
            onPressed: _showOtp ? _submit : null,
          ),
        ],
      ),
    );
  }
}
