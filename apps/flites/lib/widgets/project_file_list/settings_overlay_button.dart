import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/states/app_settings.dart';
import 'package:flites/widgets/project_file_list/overlay_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class SettingsOverlayButton extends StatelessWidget {
  const SettingsOverlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildListTile(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p4),
        ),
        trailing: selected
            ? const Icon(
                CupertinoIcons.check_mark_circled,
                size: Sizes.p16,
              )
            : null,
        title: Text(title),
      );
    }

    return OverlayButton(
      tooltip: context.l10n.menuPreferences,
      offset: const Offset(0, -12),
      buttonChild: Container(
        padding: const EdgeInsets.all(Sizes.p8),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Sizes.p8),
        ),
        child: Icon(
          CupertinoIcons.gear,
          color: context.colors.onSurface,
        ),
      ),
      overlayContent: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              dense: true,
              title: const Text('Theme Mode'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p8),
              ),
              iconColor: context.colors.onSurface,
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                buildListTile(
                  context.l10n.menuThemeLight,
                  'light',
                  appSettings.themeMode == ThemeMode.light,
                  () => appSettings.themeMode = ThemeMode.light,
                ),
                buildListTile(
                  context.l10n.menuThemeDark,
                  'dark',
                  appSettings.themeMode == ThemeMode.dark,
                  () => appSettings.themeMode = ThemeMode.dark,
                ),
                buildListTile(
                  context.l10n.menuThemeSystem,
                  'system',
                  appSettings.themeMode == ThemeMode.system,
                  () => appSettings.themeMode = ThemeMode.system,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
              child: Divider(
                color: context.colors.secondaryContainer,
                height: 1,
              ),
            ),
            Watch((context) {
              final locale = appSettings.currentLocale;
              return ExpansionTile(
                dense: true,
                title: const Text('Language'),
                shape: Border.all(color: Colors.transparent),
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                iconColor: context.colors.onSurface,
                children: [
                  buildListTile(
                    'English',
                    'en',
                    locale == const Locale('en'),
                    () => appSettings.currentLocale = const Locale('en'),
                  ),
                  buildListTile(
                    'Deutsch',
                    'de',
                    locale == const Locale('de'),
                    () => appSettings.currentLocale = const Locale('de'),
                  ),
                  buildListTile(
                    'Español',
                    'es',
                    locale == const Locale('es'),
                    () => appSettings.currentLocale = const Locale('es'),
                  ),
                  buildListTile(
                    'Français',
                    'fr',
                    locale == const Locale('fr'),
                    () => appSettings.currentLocale = const Locale('fr'),
                  ),
                  buildListTile(
                    'Italiano',
                    'it',
                    locale == const Locale('it'),
                    () => appSettings.currentLocale = const Locale('it'),
                  ),
                  buildListTile(
                    '日本語',
                    'ja',
                    locale == const Locale('ja'),
                    () => appSettings.currentLocale = const Locale('ja'),
                  ),
                  buildListTile(
                    '한국어',
                    'ko',
                    locale == const Locale('ko'),
                    () => appSettings.currentLocale = const Locale('ko'),
                  ),
                  buildListTile(
                    'Português',
                    'pt',
                    locale == const Locale('pt'),
                    () => appSettings.currentLocale = const Locale('pt'),
                  ),
                  buildListTile(
                    '中文',
                    'zh',
                    locale == const Locale('zh'),
                    () => appSettings.currentLocale = const Locale('zh'),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
