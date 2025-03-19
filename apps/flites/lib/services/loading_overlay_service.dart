import 'package:signals/signals_flutter.dart';

final showLoadingOverlay = signal(false);

/// Wraps an async operation with loading overlay
Future<T> withLoadingOverlay<T>(Future<T> Function() operation) async {
  showLoadingOverlay.value = true;
  try {
    await Future.delayed(const Duration(milliseconds: 50));
    return await operation();
  } finally {
    await Future.delayed(const Duration(milliseconds: 50));
    showLoadingOverlay.value = false;
  }
}
