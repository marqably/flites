import 'package:flites/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:menu_bar/menu_bar.dart';
import 'package:flites/main.dart';
import 'package:flites/states/app_settings.dart';
import 'package:signals/signals_flutter.dart';

class AppMenuBar extends StatelessWidget {
  const AppMenuBar({
    super.key,
    required this.child,
  });

  final Widget child;

  static const double _indicatorWidth = Sizes.p16;
  static const checkIcon = Icon(Icons.check, size: _indicatorWidth);
  static const emptySpace = SizedBox(width: _indicatorWidth);

  MenuStyle _createMenuStyle(BuildContext context) => MenuStyle(
        backgroundColor:
            WidgetStatePropertyAll(context.colors.surfaceContainerLow),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(menuBarHeight)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      );

  ButtonStyle _createButtonStyle(BuildContext context) => ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll(context.colors.surfaceContainerLow),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(menuBarHeight)),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: Sizes.p8)),
        minimumSize:
            const WidgetStatePropertyAll(Size.fromHeight(menuBarHeight)),
      );

  MenuButton _buildThemeMenuItem(String text, ThemeMode mode) {
    return MenuButton(
      text: Text(text),
      onTap: () => appSettings.themeMode = mode,
      icon: appSettings.themeMode == mode ? checkIcon : emptySpace,
    );
  }

  MenuButton _buildLanguageMenuItem(String text, String languageCode) {
    return MenuButton(
      text: Text(text),
      onTap: () => appSettings.currentLocale = Locale(languageCode),
      icon: appSettings.currentLocale.languageCode == languageCode
          ? checkIcon
          : emptySpace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return MenuBarWidget(
        barStyle: _createMenuStyle(context),
        barButtonStyle: _createButtonStyle(context),
        menuButtonStyle: _createButtonStyle(context),
        barButtons: [
          BarButton(
            text: Text(context.l10n.menuFile),
            submenu: SubMenu(
              menuItems: [
                MenuButton(
                  text: Text(context.l10n.menuPreferences),
                  submenu: SubMenu(
                    menuItems: [
                      MenuButton(
                        text: Text(context.l10n.menuTheme),
                        submenu: SubMenu(
                          menuItems: [
                            _buildThemeMenuItem(
                              context.l10n.menuThemeLight,
                              ThemeMode.light,
                            ),
                            _buildThemeMenuItem(
                              context.l10n.menuThemeDark,
                              ThemeMode.dark,
                            ),
                            _buildThemeMenuItem(
                              context.l10n.menuThemeSystem,
                              ThemeMode.system,
                            ),
                          ],
                        ),
                      ),
                      MenuButton(
                        text: Text(context.l10n.menuLanguage),
                        submenu: SubMenu(
                          menuItems: [
                            _buildLanguageMenuItem('Deutsch', 'de'),
                            _buildLanguageMenuItem('English', 'en'),
                            _buildLanguageMenuItem('Español', 'es'),
                            _buildLanguageMenuItem('Français', 'fr'),
                            _buildLanguageMenuItem('Italiano', 'it'),
                            _buildLanguageMenuItem('Japanese', 'ja'),
                            _buildLanguageMenuItem('Korean', 'ko'),
                            _buildLanguageMenuItem('Português', 'pt'),
                            _buildLanguageMenuItem('Chinese', 'zh'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        child: child,
      );
    });
  }
}
