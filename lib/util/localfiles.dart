import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Localfilesfind {
  static List localfiles = [];
  static List<FileSystemEntity> local = [];
  static Future<void> initState() async {
    localfiles.clear();
    local.clear();
    final baseStorage = await getExternalStorageDirectory();
    // print("----file*----");
    // print(baseStorage!.path);
    var files = baseStorage!.listSync();
    for (var element in files) {
      local.add(element);
      localfiles.add(element.toString().split("/").last.split(".").first);
      // print(element.toString().split("/").last.split(".").first);
    }
    // print(localfiles);
  }
}
