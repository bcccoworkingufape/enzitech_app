// 🎯 Dart imports:
import 'dart:convert';

class AppInfoModel {
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;

  AppInfoModel({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }

  factory AppInfoModel.fromMap(Map<String, dynamic> map) {
    return AppInfoModel(
      appName: map['accessToken'],
      packageName: map['user'],
      version: map['user'],
      buildNumber: map['user'],
    );
  }

  factory AppInfoModel.fromJson(String source) =>
      AppInfoModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
