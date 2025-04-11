import 'flites_image_row.dart';

class FlitesImageMap {
  final List<FlitesImageRow> rows;

  FlitesImageMap({required this.rows});

  FlitesImageMap copyWith({List<FlitesImageRow>? rows}) {
    return FlitesImageMap(rows: rows ?? this.rows);
  }
}
