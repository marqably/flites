import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_sizes.dart';
import '../../../main.dart';
import '../../../states/app_settings.dart';
import '../../../ui/panel/structure/panel_section.dart';
import '../settings_overlay_button.dart';

class MainBrand extends StatefulWidget {
  const MainBrand({super.key});

  @override
  State<MainBrand> createState() => _MainBrandState();
}

class _MainBrandState extends State<MainBrand> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: _isHovered
              ? context.colors.surfaceContainer.withValues(alpha: 40)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(vertical: Sizes.p20),
        child: PanelSection(
          verticalPadding: 0,
          showDivider: false,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: SettingsOverlayButton(
                child: Row(
                  children: [
                    // Logo
                    SvgPicture.asset(
                      appSettings.themeMode.value == ThemeMode.light
                          ? 'assets/images/flites_logo_with_text_black.svg'
                          : 'assets/images/flites_logo_with_text.svg',
                      height: Sizes.p28,
                    ),
                    const SizedBox(width: Sizes.p8),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: context.colors.onSurface,
                      size: Sizes.p12,
                    ),

                    // spacer
                    const Spacer(),

                    // Settings Button
                    Icon(
                      CupertinoIcons.gear,
                      color: context.colors.onSurface,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
