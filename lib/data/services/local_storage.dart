import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static final LocalStorage instance = LocalStorage._();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> savePortfolio(String data) async {
    await _prefs?.setString('portfolio', data);
  }

  String? getPortfolio() => _prefs?.getString('portfolio');
}
