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
        child: Watch((context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                dense: true,
                title: Text(context.l10n.themeMode),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p8),
                ),
                iconColor: context.colors.onSurface,
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  buildListTile(
                    context.l10n.menuThemeLight,
                    'light',
                    appSettings.themeMode.value == ThemeMode.light,
                    () => appSettings.setThemeMode(ThemeMode.light),
                  ),
                  buildListTile(
                    context.l10n.menuThemeDark,
                    'dark',
                    appSettings.themeMode.value == ThemeMode.dark,
                    () => appSettings.setThemeMode(ThemeMode.dark),
                  ),
                  buildListTile(
                    context.l10n.menuThemeSystem,
                    'system',
                    appSettings.themeMode.value == ThemeMode.system,
                    () => appSettings.setThemeMode(ThemeMode.system),
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
                  title: Text(context.l10n.languageSection),
                  shape: Border.all(color: Colors.transparent),
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  iconColor: context.colors.onSurface,
                  children: [
                    buildListTile(
                      'English',
                      'en',
                      locale.value == const Locale('en'),
                      () => appSettings.setLocale(const Locale('en')),
                    ),
                    buildListTile(
                      'Deutsch',
                      'de',
                      locale.value == const Locale('de'),
                      () => appSettings.setLocale(const Locale('de')),
                    ),
                    buildListTile(
                      'Español',
                      'es',
                      locale.value == const Locale('es'),
                      () => appSettings.setLocale(const Locale('es')),
                    ),
                    buildListTile(
                      'Français',
                      'fr',
                      locale.value == const Locale('fr'),
                      () => appSettings.setLocale(const Locale('fr')),
                    ),
                    buildListTile(
                      'Italiano',
                      'it',
                      locale.value == const Locale('it'),
                      () => appSettings.setLocale(const Locale('it')),
                    ),
                    buildListTile(
                      '日本語',
                      'ja',
                      locale.value == const Locale('ja'),
                      () => appSettings.setLocale(const Locale('ja')),
                    ),
                    buildListTile(
                      '한국어',
                      'ko',
                      locale.value == const Locale('ko'),
                      () => appSettings.setLocale(const Locale('ko')),
                    ),
                    buildListTile(
                      'Português',
                      'pt',
                      locale.value == const Locale('pt'),
                      () => appSettings.setLocale(const Locale('pt')),
                    ),
                    buildListTile(
                      '中文',
                      'zh',
                      locale.value == const Locale('zh'),
                      () => appSettings.setLocale(const Locale('zh')),
                    ),
                  ],
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}
