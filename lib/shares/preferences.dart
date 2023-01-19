import 'dart:convert';

import 'package:flutter_source/src/alarm/model/random_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences._();

  static const _setting = 'Setting';
  static const _multi = 'Multi';
  static const _one = 'One';
  static const _listMulti = 'ListMulti';
  static const _listOne = 'ListOne';

  static Future<void> saveSetting(
    String data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_setting, data);
  }

  static Future<String> getSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_setting) ?? '';
  }

  static Future<void> clearSetting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_setting);
  }

  static Future<void> saveMultiRandom(
    String data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_multi, data);
  }

  static Future<String> getMultiRandom() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_multi) ?? '';
  }

  static Future<void> clearMultiRandom() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_multi);
  }

  static Future<void> saveOneRandom(
    String data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_one, data);
  }

  static Future<String> getOneRandom() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_one) ?? '';
  }

  static Future<void> clearOneRandom() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_one);
  }

  static Future<void> saveListMulti(
    List<RandomModel> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final list = data.map((e) => e.toJson()).toList();
    await prefs.setString(_listMulti, json.encode(list));
  }

  static Future<List<RandomModel>> getListMulti() async {
    final prefs = await SharedPreferences.getInstance();
    final temp = prefs.getString(_listMulti);

    if (temp == null) {
      return <RandomModel>[];
    } else {
      final list = json.decode(temp) as List;
      return list
          .map((e) => RandomModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  static Future<void> clearListMulti() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listMulti);
  }

  static Future<void> saveListOne(
    List<String> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_listOne, data);
  }

  static Future<List<String>> getListOne() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_listOne) ?? <String>[];
  }

  static Future<void> clearListOne() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_listOne);
  }
}
