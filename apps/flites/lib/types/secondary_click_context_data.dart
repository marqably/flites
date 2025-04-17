import 'package:flites/types/flites_image.dart';

class SecondaryClickContextData {
  final void Function()? onDelete;
  final List<FlitesImage?> copyableData;

  const SecondaryClickContextData({
    this.onDelete,
    this.copyableData = const [],
  });
}
