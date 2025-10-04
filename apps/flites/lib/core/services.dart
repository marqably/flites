import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'error_handler.dart';

/// Interface for file operations
abstract class FileService {
  Future<FilePickerResult?> pickFiles();
  Future<bool> saveFile({
    required Uint8List bytes,
    required String fileExtension,
    required String fileName,
  });
}

/// Implementation of file service
class FileServiceImpl implements FileService {
  @override
  Future<FilePickerResult?> pickFiles() async {
    final result = await ErrorHandler.safeExecuteAsync(
      () => FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'gif', 'svg'],
      ),
      context: 'FileService.pickFiles',
    );
    return result;
  }

  @override
  Future<bool> saveFile({
    required Uint8List bytes,
    required String fileExtension,
    required String fileName,
  }) async =>
      await ErrorHandler.safeExecuteAsync(
        () async {
          if (kIsWeb) {
            await FileSaver.instance.saveFile(
              bytes: bytes,
              name: fileName,
              ext: fileExtension,
            );
            return true;
          } else {
            final downloadsDir = await getDownloadsDirectory();
            final outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Save File',
              fileName: fileName,
              initialDirectory: downloadsDir?.path,
              type: FileType.custom,
              lockParentWindow: true,
              allowedExtensions: [fileExtension],
            );

            if (outputFile == null) {
              return false;
            }

            final savedFile = File(outputFile);
            await savedFile.writeAsBytes(bytes);
            return true;
          }
        },
        context: 'FileService.saveFile',
        fallback: false,
      ) ??
      false;
}

/// Interface for project saving operations
abstract class ProjectSavingService {
  Future<bool> saveProject(String projectData);
  Future<String?> loadProject();
}

/// Implementation of project saving service
class ProjectSavingServiceImpl implements ProjectSavingService {
  ProjectSavingServiceImpl(this._fileService);
  final FileService _fileService;

  @override
  Future<bool> saveProject(String projectData) async =>
      await ErrorHandler.safeExecuteAsync(
        () async {
          final bytes = Uint8List.fromList(projectData.codeUnits);
          return _fileService.saveFile(
            bytes: bytes,
            fileExtension: 'flites',
            fileName: 'project.flites',
          );
        },
        context: 'ProjectSavingService.saveProject',
        fallback: false,
      ) ??
      false;

  @override
  Future<String?> loadProject() async {
    final result = await ErrorHandler.safeExecuteAsync(
      () async {
        final result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['flites'],
          type: FileType.custom,
        );

        if (result == null) {
          return null;
        }

        final platformFile = result.files.first;
        String projectData;

        if (kIsWeb) {
          projectData = String.fromCharCodes(platformFile.bytes!);
        } else {
          final file = File(platformFile.path!);
          projectData = await file.readAsString();
        }

        return projectData;
      },
      context: 'ProjectSavingService.loadProject',
    );
    return result;
  }
}

/// Interface for clipboard operations
abstract class ClipboardService {
  void copyImages(List<dynamic> images);
  void pasteImages();
  bool get hasData;
}

/// Implementation of clipboard service
class ClipboardServiceImpl implements ClipboardService {
  final List<dynamic> _clipboardData = [];

  @override
  bool get hasData => _clipboardData.isNotEmpty;

  @override
  void copyImages(List<dynamic> images) {
    ErrorHandler.safeExecute(
      () {
        _clipboardData
          ..clear()
          ..addAll(images);
      },
      context: 'ClipboardService.copyImages',
    );
  }

  @override
  void pasteImages() {
    ErrorHandler.safeExecute(
      () {
        // TODO(developer): Implement paste functionality
        // This would typically involve the state management system
      },
      context: 'ClipboardService.pasteImages',
    );
  }
}

/// Service locator for dependency injection
class ServiceLocator {
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();
  static final ServiceLocator _instance = ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  void register<T>(T service) {
    _services[T] = service;
  }

  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw StateError('Service of type $T not registered');
    }
    return service as T;
  }

  bool isRegistered<T>() => _services.containsKey(T);

  void reset() {
    _services.clear();
  }
}

/// Global service locator instance
final serviceLocator = ServiceLocator();

/// Initialize all services
void initializeServices() {
  // Register core services
  serviceLocator
    ..register<FileService>(FileServiceImpl())
    ..register<ProjectSavingService>(
      ProjectSavingServiceImpl(serviceLocator.get<FileService>()),
    )
    ..register<ClipboardService>(ClipboardServiceImpl());
}
