import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_sizes.dart';
import '../../core/app_state.dart';
import '../../main.dart';
import '../../services/project_saving_service.dart';
import '../../services/version_service.dart';
import '../../states/app_settings.dart';
import '../../utils/generate_sprite.dart';
import '../../utils/generate_svg_sprite.dart';
import '../../utils/svg_utils.dart';
import 'overlay_button.dart';

class SettingsOverlayButton extends StatelessWidget {
  const SettingsOverlayButton({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => OverlayButton(
        followerAnchor: Alignment.topLeft,
        targetAnchor: Alignment.bottomLeft,
        tooltip: context.l10n.menuPreferences,
        offset: const Offset(0, 12),
        buttonChild: child,
        overlayContent: (closeLayer) => SizedBox(
          width: 300 - Sizes.p16 * 2,
          child: Watch(
            (context) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // project
                ListTile(
                  dense: true,
                  title: Text(context.l10n.openProject),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  onTap: () async {
                    closeLayer();

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
                    closeLayer();
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
                    closeLayer();

                    // check if there are rows with images
                    final hasRows = appState.projectData.rows.isNotEmpty;
                    final hasImages = hasRows &&
                        appState.projectData.rows
                            .any((row) => row.images.isNotEmpty);

                    // if we don't have any rows or images, show a dialog
                    if (!hasRows || !hasImages) {
                      return;
                    }

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
                      selected: appSettings.themeMode.value == ThemeMode.light,
                      onTap: () => appSettings.setThemeMode(ThemeMode.light),
                    ),
                    buildListTile(
                      context,
                      context.l10n.menuThemeDark,
                      'dark',
                      selected: appSettings.themeMode.value == ThemeMode.dark,
                      onTap: () => appSettings.setThemeMode(ThemeMode.dark),
                    ),
                    buildListTile(
                      context,
                      context.l10n.menuThemeSystem,
                      'system',
                      selected: appSettings.themeMode.value == ThemeMode.system,
                      onTap: () => appSettings.setThemeMode(ThemeMode.system),
                    ),
                  ],
                ),
                Watch((context) {
                  final locale = appSettings.currentLocale;
                  return ExpansionTile(
                    dense: true,
                    title: Text(context.l10n.languageSection),
                    shape: Border.all(color: Colors.transparent),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                    iconColor: context.colors.onSurface,
                    children: [
                      buildListTile(
                        context,
                        'English',
                        'en',
                        selected: locale.value == const Locale('en'),
                        onTap: () => appSettings.setLocale(const Locale('en')),
                      ),
                      buildListTile(
                        context,
                        'Deutsch',
                        'de',
                        selected: locale.value == const Locale('de'),
                        onTap: () => appSettings.setLocale(const Locale('de')),
                      ),
                      buildListTile(
                        context,
                        'Español',
                        'es',
                        selected: locale.value == const Locale('es'),
                        onTap: () => appSettings.setLocale(const Locale('es')),
                      ),
                      buildListTile(
                        context,
                        'Français',
                        'fr',
                        selected: locale.value == const Locale('fr'),
                        onTap: () => appSettings.setLocale(const Locale('fr')),
                      ),
                      buildListTile(
                        context,
                        'Italiano',
                        'it',
                        selected: locale.value == const Locale('it'),
                        onTap: () => appSettings.setLocale(const Locale('it')),
                      ),
                      buildListTile(
                        context,
                        '日本語',
                        'ja',
                        selected: locale.value == const Locale('ja'),
                        onTap: () => appSettings.setLocale(const Locale('ja')),
                      ),
                      buildListTile(
                        context,
                        '한국어',
                        'ko',
                        selected: locale.value == const Locale('ko'),
                        onTap: () => appSettings.setLocale(const Locale('ko')),
                      ),
                      buildListTile(
                        context,
                        'Português',
                        'pt',
                        selected: locale.value == const Locale('pt'),
                        onTap: () => appSettings.setLocale(const Locale('pt')),
                      ),
                      buildListTile(
                        context,
                        '中文',
                        'zh',
                        selected: locale.value == const Locale('zh'),
                        onTap: () => appSettings.setLocale(const Locale('zh')),
                      ),
                    ],
                  );
                }),

                // About Flites
                divider(context),
                FutureBuilder<String>(
                  future: VersionService.getVersion(),
                  builder: (context, snapshot) {
                    final version = snapshot.data ?? '0.0.0';
                    return ListTile(
                      dense: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(context.l10n.menuAboutFlites),
                          Text(
                            'v$version',
                            style: TextStyle(
                              fontSize: Sizes.p12,
                              color: context.colors.onSurface
                                  .withValues(alpha: 0.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14),
                      onTap: () async {
                        closeLayer();
                        await launchUrl(Uri.parse('https://flites.app'));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

  Widget divider(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p12),
        child: Divider(
          color: context.colors.outline.withValues(alpha: 0.10),
          height: 1,
        ),
      );

  Widget buildListTile(
    BuildContext context,
    String title,
    String value, {
    required bool selected,
    required VoidCallback onTap,
  }) =>
      ListTile(
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
