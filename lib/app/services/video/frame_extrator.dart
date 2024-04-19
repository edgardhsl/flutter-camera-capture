import 'dart:io';

import 'package:export_video_frame/export_video_frame.dart';

class FrameExtractor {

  String path;

  FrameExtractor({required this.path});

  Future<List<File>> getBySeconds({required int seconds, double quality = 100}) async {
    final List<dynamic> list =
        await ExportVideoFrame.exportImage(path, seconds, quality);
    var result = list
        .cast<String>()
        .map((path) => File.fromUri(Uri.file(path)))
        .toList();
    return result;
  }

}