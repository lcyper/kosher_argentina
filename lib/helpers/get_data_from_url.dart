import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T> getDataFromUrl<T>(String url) async {
  final Dio dio = Dio();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data;
  try {
    Response<String> response = await dio.get<String>(url);
    prefs.setString(url, response.data!);
    debugPrint('Guardando datos en shared preferences');
    data = response.data!;
    // } on DioException catch (e) {
    //   throw e.type.toString();
  } catch (e) {
    debugPrint('Trayendo datos desde shared preferences');
    data = prefs.getString(url) ?? '';
  }
  if (data.isEmpty) {
    throw 'Error al traer los datos';
  } else {
    return jsonDecode(data) as T;
  }
}
