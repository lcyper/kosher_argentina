import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosher_ar/models/alert_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertsService {
  Future<List<AlertModel>> getData() async {
    List<Map<String, dynamic>> alertList = List<Map<String, dynamic>>.from(
        await _getDataFromUrl<List<dynamic>>(
            'https://www.kosher.org.ar/api/alertas.php'));

    return List<AlertModel>.from(alertList.map((x) => AlertModel.fromJson(x)))
        .where(
          (AlertModel alertModel) => alertModel.mostrar.toLowerCase() == "s",
        )
        .toList();
  }

  // TODO: extraer a un archivo de utilidades y usar esta funcion en todas las peticiones.
  Future<T> _getDataFromUrl<T>(String url) async {
    final Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data;
    try {
      Response response = await dio.get(url);
      prefs.setString('alertList', response.data);
      debugPrint('Guardando datos en shared preferences');
      data = response.data;
      // } on DioException catch (e) {
      //   throw e.type.toString();
    } catch (e) {
      debugPrint('Trayendo datos desde shared preferences');
      data = prefs.getString('alertList') ?? '';
    }
    if (data.isEmpty) {
      throw 'Error al traer los datos';
    } else {
      return jsonDecode(data) as T;
    }
  }
}
