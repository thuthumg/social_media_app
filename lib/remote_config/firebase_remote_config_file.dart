import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConfigFile {
  static final FirebaseRemoteConfigFile _singleton =
  FirebaseRemoteConfigFile._internal();

  factory FirebaseRemoteConfigFile() {
    return _singleton;
  }

  FirebaseRemoteConfigFile._internal() {
    initializeRemoteConfig();
    _remoteConfig.fetchAndActivate();
  }

  final _remoteConfig = FirebaseRemoteConfig.instance;

  void initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
  }

  MaterialColor getThemeColorFromRemoteConfig() {
    debugPrint(
        "Remote Config Theme Color Value ======> ${_remoteConfig.getString(remoteConfigThemeColor)}");
    return MaterialColor(
      int.parse(_remoteConfig.getString(remoteConfigThemeColor)),
      const {},
    );
  }
}

const String remoteConfigThemeColor = "theme_color";
