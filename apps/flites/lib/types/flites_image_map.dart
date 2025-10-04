import 'flites_image_row.dart';

class FlitesImageMap {
  FlitesImageMap({required this.rows, this.projectName});

  factory FlitesImageMap.fromJson(Map<String, dynamic> json) => FlitesImageMap(
        projectName: json['projectName'],
        rows: json['rows']
            .map((row) => FlitesImageRow.fromJson(row))
            .toList()
            .cast<FlitesImageRow>(),
      );
  final String? projectName;
  final List<FlitesImageRow> rows;

  FlitesImageMap copyWith({
    String? projectName,
    List<FlitesImageRow>? rows,
  }) =>
      FlitesImageMap(
        projectName: projectName ?? this.projectName,
        rows: rows ?? this.rows,
      );

  Map<String, dynamic> toJson() => {
        'projectName': projectName,
        'rows': rows.map((row) => row.toJson()).toList(),
      };
}
