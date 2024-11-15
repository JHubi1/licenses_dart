import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart' show DateFormat;

void main() async {
  var lib =
      "${File(Platform.script.toFilePath()).parent.parent.path}${Platform.pathSeparator}lib";

  var licensesBase =
      "$lib${Platform.pathSeparator}src${Platform.pathSeparator}licenses";
  Directory(licensesBase).deleteSync(recursive: true);

  var licenses = "$licensesBase${Platform.pathSeparator}generated";

  var indexFile = File("$licensesBase${Platform.pathSeparator}index.dart")
    ..createSync(recursive: true)
    ..writeAsStringSync("");

  List<String> index = [];

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
      var name = (i.name.split("/").last.toLowerCase().split(".")..removeLast())
          .join(".");
      index.add(name);
      File("$licenses${Platform.pathSeparator}${name.replaceAll(".", "")}.dart")
          .writeAsStringSync(
              "// This is an automatically generated file. DO NOT edit it manually!\n// If you want to update its data, rerun `./script/download.dart`\n\n// ignore_for_file: file_names\n\nMap<String, dynamic> content = ${JsonEncoder.withIndent(" " * 4).convert(jsonDecode(String.fromCharCodes(i.content))).replaceAll(r"$", r"\$")};");
      print("done");
    }
  }

  stdout.write("Creating index... ");
  var indexContent =
      "// This is an automatically generated file. DO NOT edit it manually!\n// If you want to update its data, rerun `./script/download.dart`\n\n// ignore_for_file: no_leading_underscores_for_library_prefixes, unused_import, library_prefixes\n\n";

  for (var i in index) {
    indexContent +=
        "import 'generated/${i.replaceAll(".", "")}.dart' as _${i.replaceAll(".", "").replaceAll("-", "_").replaceAll("+", "_plus")};\n";
  }
  indexContent += "\n\nMap<String, dynamic> get content => {\n";
  for (var i in index) {
    indexContent +=
        '    "$i": _${i.replaceAll(".", "").replaceAll("-", "_").replaceAll("+", "_plus")}.content,\n';
  }
  indexContent += "};\n";

  indexFile.writeAsStringSync(indexContent);
  print("done");

  stdout.write("Formatting project... ");
  Directory.current = lib;
  Process.runSync("dart", ["format", "."]);
  Process.runSync("dart", ["fix", "--apply"]);
  print("done");

  stdout.write("Updating README.md... ");
  var readme = File(
      "${File(Platform.script.toFilePath()).parent.parent.path}${Platform.pathSeparator}README.md");
  if (readme.existsSync()) {
    var content = readme.readAsStringSync();
    content = content.replaceAll(RegExp(r"> Last updated: .*"),
        "> Last updated: ${DateFormat("yyyy-MM-dd HH:mm", "en_US").format(DateTime.now().toUtc())} UTC");
    readme.writeAsStringSync(content);
    print("done");
  } else {
    print("not found");
  }
}
