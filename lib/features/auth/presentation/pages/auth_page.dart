import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_icon_button.dart';
import 'package:yalla_5roga/features/auth/presentation/widgets/auth_form.dart';
import 'package:yalla_5roga/features/auth/presentation/widgets/auth_header.dart';
import 'package:yalla_5roga/features/auth/presentation/widgets/auth_tabs.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: context.palette.surface,
      body: SafeArea(
        child: ListView(
          padding: Responsive.padding(horizontal: 24, top: 12, bottom: 24),
          children: [
            Row(
              children: [
                AppIconButton(icon: Icons.chevron_left, onTap: Get.back),
                const Spacer(),
                Icon(Icons.auto_awesome, color: AppColors.brand600, size: 16.w),
                6.gapW,
                Text(
                  l10n.appName,
                  style: TextStyle(
                    color: AppColors.brand600,
                    fontWeight: FontWeight.w800,
                    fontSize: Responsive.fontBody,
                  ),
                ),
                const Spacer(),
                SizedBox(width: 40.w),
              ],
            ),
            28.gapH,
            AuthHeader(
              eyebrow: l10n.welcomeBack,
              title: _isLogin ? l10n.letsGetYouOut : l10n.joinTheFun,
              subtitle: _isLogin ? l10n.authLoginSubtitle : l10n.authSignupSubtitle,
            ),
            Responsive.spaceLg.gapH,
            AuthTabs(
              isLogin: _isLogin,
              onChanged: (isLogin) => setState(() => _isLogin = isLogin),
            ),
            Responsive.spaceLg.gapH,
            AuthForm(isLogin: _isLogin, key: ValueKey(_isLogin)),
            Responsive.spaceMd.gapH,
            Text.rich(
              TextSpan(
                text: _isLogin ? '${l10n.newHere} ' : '${l10n.alreadyMember} ',
                style: TextStyle(color: context.palette.textMuted, fontSize: 12.sp),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin ? l10n.createYourAccount : l10n.login,
                        style: TextStyle(
                          color: AppColors.brand600,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
