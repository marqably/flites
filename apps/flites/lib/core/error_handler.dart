import 'package:flutter/foundation.dart';

/// Base class for all application errors
abstract class AppError implements Exception {
  const AppError(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      'AppError: $message${code != null ? ' (Code: $code)' : ''}';
}

/// File operation errors
class FileError extends AppError {
  const FileError(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Image processing errors
class ImageProcessingError extends AppError {
  const ImageProcessingError(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// State management errors
class StateError extends AppError {
  const StateError(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Network/API errors
class NetworkError extends AppError {
  const NetworkError(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation errors
class ValidationError extends AppError {
  const ValidationError(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Centralized error handling for the application
class ErrorHandler {
  // Private constructor to prevent instantiation
  ErrorHandler._();
  static void handleError(
    Object error,
    StackTrace stackTrace, {
    String? context,
    bool showToUser = false,
  }) {
    // Log the error
    debugPrint('Error${context != null ? ' in $context' : ''}: $error');
    debugPrint('Stack trace: $stackTrace');

    // In production, you might want to send this to a crash reporting service
    if (kReleaseMode) {
      // TODO(developer): Send to crash reporting service (e.g., Sentry, Crashlytics)
    }

    // Show user-friendly message if requested
    if (showToUser) {
      _showUserFriendlyMessage(error);
    }
  }

  static void handleAppError(
    AppError error, {
    String? context,
    bool showToUser = false,
  }) {
    debugPrint(
        'AppError${context != null ? ' in $context' : ''}: ${error.message}',);
    if (error.stackTrace != null) {
      debugPrint('Stack trace: ${error.stackTrace}');
    }

    if (showToUser) {
      _showUserFriendlyMessage(error);
    }
  }

  static void _showUserFriendlyMessage(Object error) {
    String message;

    if (error is AppError) {
      message = error.message;
    } else if (error is Exception) {
      message = error.toString();
    } else {
      message = 'An unexpected error occurred. Please try again.';
    }

    // TODO(developer): Show user-friendly dialog or snackbar
    debugPrint('User message: $message');
  }

  /// Wraps a function with error handling
  static T? safeExecute<T>(
    T Function() function, {
    String? context,
    T? fallback,
  }) {
    try {
      return function();
    } on Exception catch (error, stackTrace) {
      handleError(error, stackTrace, context: context);
      return fallback;
    }
  }

  /// Wraps an async function with error handling
  static Future<T?> safeExecuteAsync<T>(
    Future<T> Function() function, {
    String? context,
    T? fallback,
  }) async {
    try {
      return await function();
    } on Exception catch (error, stackTrace) {
      handleError(error, stackTrace, context: context);
      return fallback;
    }
  }
}

/// Extension to add error handling to any function
extension ErrorHandlingExtension<T> on T Function() {
  T? safeExecute({String? context, T? fallback}) =>
      ErrorHandler.safeExecute(this, context: context, fallback: fallback);
}

/// Extension to add error handling to any async function
extension AsyncErrorHandlingExtension<T> on Future<T> Function() {
  Future<T?> safeExecuteAsync({String? context, T? fallback}) =>
      ErrorHandler.safeExecuteAsync(this, context: context, fallback: fallback);
}
