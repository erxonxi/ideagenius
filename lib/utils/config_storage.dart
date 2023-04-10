import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Config {
  String openAiKey;

  Config({
    required this.openAiKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': openAiKey,
    };
  }

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      openAiKey: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Config.fromJson(String source) => Config.fromMap(json.decode(source));
}

class ConfigStorage {
  static Future<Config> getConfig() async {
    final file = await _localFile;
    final contents = await file.readAsString();
    final note = json.decode(contents) as Map<String, dynamic>;
    return Config.fromMap(note);
  }

  static Future<void> setConfig(Config config) async {
    final file = await _localFile;
    await file.writeAsString(json.encode(config.toMap()));
  }

  static Future<File> get _localFile async {
    final path = await _localPath;

    final file = File('$path/config.json');
    if (!await file.exists()) {
      await file.create();
      file.writeAsString(Config(openAiKey: "").toJson());
    }

    return file;
  }

  static Future<String> get _localPath async {
    final directory =
        await getApplicationDocumentsDirectory(); // from path_provider package
    return directory.path;
  }
}
