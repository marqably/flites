import 'flites_image.dart';

class SecondaryClickContextData {
  const SecondaryClickContextData({
    this.onDelete,
    this.copyableData = const [],
  });
  final void Function()? onDelete;
  final List<FlitesImage?> copyableData;
}
