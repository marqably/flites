import 'package:flites/feature_kits/code_wizards/base_code_wizard.dart';
import 'package:flites/feature_kits/code_wizards/flutter_flame/flutter_flame_code_wizard.dart';

enum CodeWizards {
  none,
  flutterFlame,
  ;

  BaseCodeWizard? getCodeWizard() {
    switch (this) {
      case CodeWizards.none:
        return null;
      case CodeWizards.flutterFlame:
        return FlutterFlameCodeWizard();
    }
  }

  static Map<CodeWizards, String> getCodeWizardMap() {
    return {
      CodeWizards.none: 'None',
      CodeWizards.flutterFlame: 'Flutter Flame',
    };
  }
}
