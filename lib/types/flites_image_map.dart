import 'flites_image_row.dart';

class FlitesImageMap {
  final String? projectName;
  final List<FlitesImageRow> rows;

  FlitesImageMap({required this.rows, this.projectName});

  FlitesImageMap copyWith({
    String? projectName,
    List<FlitesImageRow>? rows,
  }) {
    return FlitesImageMap(
      projectName: projectName ?? this.projectName,
      rows: rows ?? this.rows,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }

  factory FlitesImageMap.fromJson(Map<String, dynamic> json) {
    return FlitesImageMap(
      projectName: json['projectName'],
      rows: (json['rows'].map((row) => FlitesImageRow.fromJson(row)).toList())
          .cast<FlitesImageRow>(),
    );
  }
}
