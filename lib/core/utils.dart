import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';

Future<File?> pickAudio() async {
  try {
    final filePick = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (filePick != null) {
      return File(filePick.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePick = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePick != null) {
      return File(filePick.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String hex){
  return Color(int.parse(hex , radix:16) + 0xFF000000);
}