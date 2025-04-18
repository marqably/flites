import 'package:flites/constants/app_sizes.dart';
import 'package:flites/main.dart';
import 'package:flites/ui/panel/structure/panel_section.dart';
import 'package:flites/widgets/project_file_list/settings_overlay_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainBrand extends StatefulWidget {
  const MainBrand({super.key});

  @override
  State<MainBrand> createState() => _MainBrandState();
}

class _MainBrandState extends State<MainBrand> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  SvgPicture.asset(
                    'assets/images/flites_logo_with_text.svg',
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
}
