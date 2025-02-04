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

  static const double _indicatorWidth = 16.0;
  static const double _menuHeight = 24.0;
  static const checkIcon = Icon(Icons.check, size: _indicatorWidth);
  static const emptySpace = SizedBox(width: _indicatorWidth);

  MenuStyle _createMenuStyle(BuildContext context) => MenuStyle(
        backgroundColor:
            WidgetStatePropertyAll(context.colors.surfaceContainerLow),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_menuHeight)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      );

  ButtonStyle _createButtonStyle(BuildContext context) => ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll(context.colors.surfaceContainerLow),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_menuHeight)),
        padding:
            const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(_menuHeight)),
      );

  MenuButton _buildThemeMenuItem(String text, ThemeMode mode) {
    return MenuButton(
      text: Text(text),
      onTap: () => AppSettings.themeMode = mode,
      icon: AppSettings.themeMode == mode ? checkIcon : emptySpace,
    );
  }

  MenuButton _buildLanguageMenuItem(String text, String languageCode) {
    return MenuButton(
      text: Text(text),
      onTap: () => AppSettings.currentLocale = Locale(languageCode),
      icon: AppSettings.currentLocale.languageCode == languageCode
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
