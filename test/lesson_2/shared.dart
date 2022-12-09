import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final ps = Platform.pathSeparator;
  final String testPathName;
  final String taskDocumentsPathName;

  String getCurrentTestPath() {
    final projectPath = Directory("").absolute.path;
    print("Got project path: $projectPath");
    final correctedPath = projectPath.endsWith(ps)
        ? projectPath.substring(0, projectPath.length - 1)
        : projectPath;
    return "$correctedPath$ps$testPathName$ps$taskDocumentsPathName";
  }

  FakePathProviderPlatform({
    required this.testPathName,
    required this.taskDocumentsPathName,
  });

  @override
  Future<String?> getTemporaryPath() async => getCurrentTestPath();

  @override
  Future<String?> getApplicationSupportPath() async => getCurrentTestPath();

  @override
  Future<String?> getLibraryPath() async => getCurrentTestPath();

  @override
  Future<String?> getApplicationDocumentsPath() async => getCurrentTestPath();

  @override
  Future<String?> getExternalStoragePath() async => getCurrentTestPath();

  @override
  Future<List<String>?> getExternalCachePaths() async =>
      <String>[getCurrentTestPath()];

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async =>
      <String>[getCurrentTestPath()];

  @override
  Future<String?> getDownloadsPath() async => getCurrentTestPath();
}
