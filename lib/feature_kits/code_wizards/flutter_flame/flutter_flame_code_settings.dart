/// Settings for the Flutter Flame code generator used in the sidebar and for the generation
class FlutterFlameCodeGenSettings {
  final bool hitboxes;

  FlutterFlameCodeGenSettings({
    required this.hitboxes,
  });

  Map<String, dynamic> toMap() {
    return {
      'hitboxes': hitboxes,
    };
  }

  static FlutterFlameCodeGenSettings fromMap(Map<String, dynamic> map) {
    return FlutterFlameCodeGenSettings(
      hitboxes: map['hitboxes'] ?? true,
    );
  }
}
