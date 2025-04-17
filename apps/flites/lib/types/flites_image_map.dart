import 'flites_image_row.dart';

class FlitesImageMap {
  final List<FlitesImageRow> rows;

  FlitesImageMap({required this.rows});

  FlitesImageMap copyWith({List<FlitesImageRow>? rows}) {
    return FlitesImageMap(rows: rows ?? this.rows);
  }

  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }

  factory FlitesImageMap.fromJson(Map<String, dynamic> json) {
    return FlitesImageMap(
      rows: (json['rows'].map((row) => FlitesImageRow.fromJson(row)).toList())
          .cast<FlitesImageRow>(),
    );
  }
}
