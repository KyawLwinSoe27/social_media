import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConf {
  static final FirebaseRemoteConf _singleton = FirebaseRemoteConf._internal();
  factory FirebaseRemoteConf() {
    return _singleton;
  }
  FirebaseRemoteConf._internal() {
    initializeRemoteConfig();
    remoteConfig.fetchAndActivate();
  }
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  void initializeRemoteConfig() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
  }

  MaterialColor getThemeColorFromRemoteConfig() {
    return MaterialColor(
      int.parse(remoteConfig.getString(remoteConfigThemeColor)),
      const {},
    );
  }

}
const String remoteConfigThemeColor = "theme_color";
