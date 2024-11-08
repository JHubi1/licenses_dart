import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart' show DateFormat;

void main() async {
  var lib =
      "${File(Platform.script.toFilePath()).parent.parent.path}${Platform.pathSeparator}lib";
  var licenses =
      "$lib${Platform.pathSeparator}src${Platform.pathSeparator}licenses";

  print("Creating directory: $licenses");
  Directory(licenses).createSync(recursive: true);

  stdout.write("Downloading licenses archive... ");
  var file = File("$lib${Platform.pathSeparator}licenses.zip");
  if (!file.existsSync()) {
    var download = await http.get(Uri.parse(
        "https://api.github.com/repos/spdx/license-list-data/zipball"));
    file.writeAsBytesSync(download.bodyBytes);
  }
  print("done");

  var archive = ZipDecoder().decodeBuffer(InputFileStream(file.path));
  for (var i in archive.files) {
    if (!i.isFile) continue;
    if (i.name.contains("json/details")) {
      stdout.write("Extracting ${i.name.split("/").last.toLowerCase()}... ");
      File("$licenses${Platform.pathSeparator}${i.name.split("/").last.toLowerCase()}")
          .writeAsBytesSync(i.content);
      print("done");
    }
  }

  stdout.write("Updating README.md... ");
  var readme = File(
      "${File(Platform.script.toFilePath()).parent.parent.path}${Platform.pathSeparator}README.md");
  if (readme.existsSync()) {
    var content = readme.readAsStringSync();
    content = content.replaceAll(RegExp(r"> Last updated: .*"),
        "> Last updated: ${DateFormat("yyyy-MM-dd HH:mm", "en_US").format(DateTime.now().toUtc())} UTC");
    readme.writeAsStringSync(content);
  } else {
    print("not found");
  }
}
