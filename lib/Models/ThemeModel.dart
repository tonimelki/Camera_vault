import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeModel with ChangeNotifier {
  ThemeMode _mode;
  final _storage = FlutterSecureStorage();
  ThemeMode get mode => _mode;
  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _storage.write(key: 'theme', value: _mode.toString());
    notifyListeners();
  }

  Future<String> loadTheme() async {
    String theme = await _storage.read(key: 'theme') as String;
    return theme;
  }
}
