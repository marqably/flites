import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/services/project_saving_service.dart';
import 'package:flites/states/app_settings.dart';
import 'package:flites/utils/generate_sprite.dart';
import 'package:flites/utils/generate_svg_sprite.dart';
import 'package:flites/utils/svg_utils.dart';
import 'package:flites/widgets/project_file_list/overlay_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsOverlayButton extends StatelessWidget {
  final Widget child;

  const SettingsOverlayButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return OverlayButton(
      followerAnchor: Alignment.topLeft,
      targetAnchor: Alignment.bottomLeft,
      tooltip: context.l10n.menuPreferences,
      offset: const Offset(0, 12),
      buttonChild: child,
      overlayContent: SizedBox(
        width: 300 - Sizes.p16 * 2,
        child: Watch((context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // project
              ListTile(
                dense: true,
                title: Text(context.l10n.openProject),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () async {
                  final projectState =
                      await ProjectSavingService().loadProjectFile();
                  if (projectState != null) {
                    ProjectSavingService().setProjectState(projectState);
                  }
                },
              ),
              ListTile(
                dense: true,
                title: Text(context.l10n.saveProject),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () {
                  ProjectSavingService().saveProject();
                },
              ),

              // export
              divider(context),
              ListTile(
                dense: true,
                title: Text(context.l10n.exportSpritemap),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () {
                  if (SvgUtils.allImagesInProjectAreSvg) {
                    GenerateSvgSprite.exportSpriteMap();
                  } else {
                    GenerateSprite.exportSpriteMap();
                  }
                },
              ),

              // settings
              divider(context),
              ExpansionTile(
                dense: true,
                title: Text(context.l10n.themeMode),
                shape: Border.all(color: Colors.transparent),
                iconColor: context.colors.onSurface,
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  buildListTile(
                    context,
                    context.l10n.menuThemeLight,
                    'light',
                    appSettings.themeMode.value == ThemeMode.light,
                    () => appSettings.setThemeMode(ThemeMode.light),
                  ),
                  buildListTile(
                    context,
                    context.l10n.menuThemeDark,
                    'dark',
                    appSettings.themeMode.value == ThemeMode.dark,
                    () => appSettings.setThemeMode(ThemeMode.dark),
                  ),
                  buildListTile(
                    context,
                    context.l10n.menuThemeSystem,
                    'system',
                    appSettings.themeMode.value == ThemeMode.system,
                    () => appSettings.setThemeMode(ThemeMode.system),
                  ),
                ],
              ),
              Watch((context) {
                final locale = appSettings.currentLocale;
                return ExpansionTile(
                  dense: true,
                  title: Text(context.l10n.languageSection),
                  shape: Border.all(color: Colors.transparent),
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  iconColor: context.colors.onSurface,
                  children: [
                    buildListTile(
                      context,
                      'English',
                      'en',
                      locale.value == const Locale('en'),
                      () => appSettings.setLocale(const Locale('en')),
                    ),
                    buildListTile(
                      context,
                      'Deutsch',
                      'de',
                      locale.value == const Locale('de'),
                      () => appSettings.setLocale(const Locale('de')),
                    ),
                    buildListTile(
                      context,
                      'Español',
                      'es',
                      locale.value == const Locale('es'),
                      () => appSettings.setLocale(const Locale('es')),
                    ),
                    buildListTile(
                      context,
                      'Français',
                      'fr',
                      locale.value == const Locale('fr'),
                      () => appSettings.setLocale(const Locale('fr')),
                    ),
                    buildListTile(
                      context,
                      'Italiano',
                      'it',
                      locale.value == const Locale('it'),
                      () => appSettings.setLocale(const Locale('it')),
                    ),
                    buildListTile(
                      context,
                      '日本語',
                      'ja',
                      locale.value == const Locale('ja'),
                      () => appSettings.setLocale(const Locale('ja')),
                    ),
                    buildListTile(
                      context,
                      '한국어',
                      'ko',
                      locale.value == const Locale('ko'),
                      () => appSettings.setLocale(const Locale('ko')),
                    ),
                    buildListTile(
                      context,
                      'Português',
                      'pt',
                      locale.value == const Locale('pt'),
                      () => appSettings.setLocale(const Locale('pt')),
                    ),
                    buildListTile(
                      context,
                      '中文',
                      'zh',
                      locale.value == const Locale('zh'),
                      () => appSettings.setLocale(const Locale('zh')),
                    ),
                  ],
                );
              }),

              // About Flites
              divider(context),
              ListTile(
                dense: true,
                title: Text(context.l10n.menuAboutFlites),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                onTap: () async {
                  launchUrl(Uri.parse('https://flites.app'));
                },
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
      child: Divider(
        color: context.colors.outline.withValues(alpha: 0.10),
        height: 1,
      ),
    );
  }

  Widget buildListTile(
    BuildContext context,
    String title,
    String value,
    bool selected,
    VoidCallback onTap,
  ) {
    return ListTile(
      dense: true,
      selected: selected,
      onTap: onTap,
      selectedTileColor: context.colors.surfaceContainerLowest,
      selectedColor: context.colors.onSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p4),
      ),
      trailing: selected
          ? const Icon(
              CupertinoIcons.checkmark_alt,
              size: Sizes.p20,
            )
          : null,
      title: Text(title),
    );
  }
}
