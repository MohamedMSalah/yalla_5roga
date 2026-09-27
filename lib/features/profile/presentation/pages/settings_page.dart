import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yalla_5roga/core/localization/locale_provider.dart';
import 'package:yalla_5roga/core/theme/app_colors.dart';
import 'package:yalla_5roga/core/theme/theme_provider.dart';
import 'package:yalla_5roga/core/utils/app_launcher.dart';
import 'package:yalla_5roga/core/utils/extensions.dart';
import 'package:yalla_5roga/core/widgets/app_alert.dart';
import 'package:yalla_5roga/core/widgets/app_snackbar.dart';
import 'package:yalla_5roga/core/widgets/app_switch.dart';
import 'package:yalla_5roga/core/widgets/language_choice.dart';
import 'package:yalla_5roga/core/widgets/custom_button.dart';
import 'package:yalla_5roga/core/widgets/image_source_sheet.dart';
import 'package:yalla_5roga/features/auth/presentation/pages/auth_page.dart';
import 'package:yalla_5roga/features/auth/presentation/providers/auth_provider.dart';
import 'package:yalla_5roga/features/profile/presentation/pages/about_developer_page.dart';
import 'package:yalla_5roga/features/profile/presentation/pages/profile_info_page.dart';
import 'package:yalla_5roga/features/profile/presentation/widgets/about_developer_card.dart';
import 'package:yalla_5roga/features/profile/presentation/widgets/profile_header.dart';
import 'package:yalla_5roga/features/profile/presentation/widgets/profile_stats.dart';
import 'package:yalla_5roga/features/outings/presentation/pages/saved_outings_page.dart';
import 'package:yalla_5roga/features/outings/presentation/providers/saved_outings_provider.dart';
import 'package:yalla_5roga/features/profile/presentation/widgets/settings_group.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _push = true;

  Future<void> _logout() async {
    final l10n = context.l10n;
    final confirmed = await AppAlert.confirm(
      title: l10n.logoutConfirmTitle,
      message: l10n.logoutConfirmBody,
      confirmText: l10n.logOut,
      cancelText: l10n.cancel,
    );
    if (!confirmed || !mounted) return;
    await context.read<AuthProvider>().logout();
    AppSnackBar.show(l10n.signedOut);
    Get.offAll(() => const AuthPage());
  }

  Future<void> _editImage() async {
    final url = await ImageSourceSheet.pick(title: context.l10n.changeProfileImage);
    if (url == null || !mounted) return;
    await context.read<AuthProvider>().updateProfile(imageUrl: url);
    if (!mounted) return;
    AppSnackBar.show(context.l10n.profileUpdated);
  }

  Future<void> _deleteAccount() async {
    final l10n = context.l10n;
    final confirmed = await AppAlert.confirm(
      title: l10n.deleteAccountTitle,
      message: l10n.deleteAccountBody,
      confirmText: l10n.deleteAccount,
      cancelText: l10n.cancel,
    );
    if (!confirmed || !mounted) return;
    await context.read<AuthProvider>().logout();
    AppSnackBar.show(l10n.accountDeleted);
    Get.offAll(() => const AuthPage());
  }

  Future<void> _openLink(String url) async {
    final opened = await AppLauncher.open(url);
    if (!opened && mounted) {
      AppSnackBar.show(context.l10n.couldNotOpenLink);
    }
  }

  Widget _chevron(BuildContext context) {
    return Icon(Icons.chevron_right, color: context.palette.border, size: 20.w);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = context.watch<AuthProvider>().user;
    final locale = context.watch<LocaleProvider>();
    final theme = context.watch<ThemeProvider>();
    final savedOutings = context.watch<SavedOutingsProvider>().saved;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: Responsive.padding(horizontal: 20, top: 48, bottom: 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.slate950, AppColors.brand700, Color(0xFF8B5CF6)],
            ),
          ),
          child: ProfileHeader(
            user: user,
            onLogout: _logout,
            onEditImage: _editImage,
          ),
        ),
        Padding(
          padding: Responsive.padding(horizontal: 20, bottom: 24),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(0, -18.h),
                child: const ProfileStats(),
              ),
              SettingsGroup(
                title: l10n.accountSettings,
                children: [
                  SettingsTile(
                    icon: Icons.phone_outlined,
                    title: l10n.phone,
                    subtitle: user?.phone ?? '+20 100 123 4567',
                    background: const Color(0xFFEDE9FE),
                    foreground: const Color(0xFF7C3AED),
                  ),
                  SettingsTile(
                    icon: Icons.calendar_today_outlined,
                    title: l10n.memberSince,
                    subtitle: l10n.memberSinceDate,
                    background: AppColors.amber100,
                    foreground: AppColors.amber700,
                  ),
                  SettingsTile(
                    icon: Icons.bookmark_outline,
                    title: l10n.mySaved,
                    subtitle: savedOutings.isEmpty ? l10n.mySavedSubtitle : l10n.savedCount(savedOutings.length),
                    background: AppColors.brand50,
                    foreground: AppColors.brand600,
                    trailing: _chevron(context),
                    onTap: () => Get.to(() => const SavedOutingsPage()),
                  ),
                  SettingsTile(
                    icon: theme.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                    title: l10n.darkTheme,
                    subtitle: l10n.useDarkColors,
                    background: const Color(0xFFEDE9FE),
                    foreground: const Color(0xFF7C3AED),
                    trailing: AppSwitch(
                      value: theme.isDark,
                      onChanged: (value) async {
                        await theme.setDark(value);
                        AppSnackBar.show(l10n.themeChanged);
                      },
                    ),
                  ),
                ],
              ),
              12.gapH,
              SettingsGroup(
                title: l10n.preferences,
                children: [
                  SettingsTile(
                    icon: Icons.notifications_active_outlined,
                    title: l10n.notifications,
                    subtitle: l10n.votesPlansReminders,
                    background: AppColors.rose50,
                    foreground: AppColors.rose500,
                    trailing: AppSwitch(
                      value: _push,
                      onChanged: (value) => setState(() => _push = value),
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.language,
                    title: l10n.appLanguage,
                    subtitle: locale.isRtl ? l10n.arabic : l10n.english,
                    background: const Color(0xFFD1FAE5),
                    foreground: const Color(0xFF059669),
                    trailing: const LanguageChoice(),
                  ),
                ],
              ),
              12.gapH,
              SettingsGroup(
                title: l10n.support,
                children: [
                  SettingsTile(
                    icon: Icons.help_outline,
                    title: l10n.helpAndFaq,
                    background: AppColors.amber100,
                    foreground: AppColors.amber700,
                    trailing: _chevron(context),
                    onTap: () => Get.to(
                      () => ProfileInfoPage(
                        title: l10n.helpAndFaq,
                        children: [
                          ProfileInfoBlock(title: l10n.faqCreateOuting, body: l10n.faqCreateOutingAnswer),
                          ProfileInfoBlock(title: l10n.faqGroups, body: l10n.faqGroupsAnswer),
                          ProfileInfoBlock(title: l10n.faqInvite, body: l10n.faqInviteAnswer),
                        ],
                      ),
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.mail_outline,
                    title: l10n.contactUs,
                    subtitle: l10n.getInTouch,
                    background: const Color(0xFFE0F2FE),
                    foreground: const Color(0xFF0284C7),
                    trailing: Icon(Icons.arrow_outward, size: 16.w, color: context.palette.textMuted),
                    onTap: () => _openLink(
                      'mailto:${AboutDeveloperCard.contactEmail}?subject=Yalla%205roga',
                    ),
                  ),
                ],
              ),
              12.gapH,
              SettingsGroup(
                title: l10n.about,
                children: [
                  SettingsTile(
                    icon: Icons.info_outline,
                    title: l10n.aboutYalla5roga,
                    background: AppColors.brand50,
                    foreground: AppColors.brand600,
                    trailing: _chevron(context),
                    onTap: () => Get.to(
                      () => ProfileInfoPage(
                        title: l10n.aboutYalla5roga,
                        children: [ProfileInfoBlock(title: l10n.appName, body: l10n.aboutAppBody)],
                      ),
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: l10n.privacyPolicy,
                    background: const Color(0xFFEDE9FE),
                    foreground: const Color(0xFF7C3AED),
                    trailing: _chevron(context),
                    onTap: () => Get.to(
                      () => ProfileInfoPage(
                        title: l10n.privacyPolicy,
                        children: [ProfileInfoBlock(title: l10n.privacyPolicy, body: l10n.privacyPolicyBody)],
                      ),
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.termsAndConditions,
                    background: context.palette.surfaceMuted,
                    foreground: context.palette.textPrimary,
                    trailing: _chevron(context),
                    onTap: () => Get.to(
                      () => ProfileInfoPage(
                        title: l10n.termsAndConditions,
                        children: [ProfileInfoBlock(title: l10n.termsAndConditions, body: l10n.termsBody)],
                      ),
                    ),
                  ),
                ],
              ),
              12.gapH,
              SettingsGroup(
                title: l10n.developer,
                children: [
                  SettingsTile(
                    icon: Icons.computer_outlined,
                    title: l10n.aboutDeveloper,
                    subtitle: l10n.developerName,
                    background: AppColors.brand50,
                    foreground: AppColors.brand600,
                    trailing: _chevron(context),
                    onTap: () => Get.to(() => const AboutDeveloperPage()),
                  ),
                ],
              ),
              Responsive.spaceLg.gapH,
              CustomButton(
                label: l10n.deleteAccount,
                icon: Icons.delete_outline,
                variant: AppButtonVariant.danger,
                onPressed: _deleteAccount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
