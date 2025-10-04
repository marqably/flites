/// Settings for the Flutter Flame code generator used in the sidebar and for the generation
class FlutterFlameCodeGenSettings {
  FlutterFlameCodeGenSettings({
    required this.hitboxes,
  });

  FlutterFlameCodeGenSettings.fromMap(Map<String, dynamic> map)
      : hitboxes = map['hitboxes'] ?? true;

  final bool hitboxes;

  Map<String, dynamic> toMap() => {
        'hitboxes': hitboxes,
      };
}
