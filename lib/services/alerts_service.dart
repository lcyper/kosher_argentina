import 'package:kosher_ar/helpers/get_data_from_url.dart';
import 'package:kosher_ar/models/alert_model.dart';

class AlertsService {
  Future<List<AlertModel>> getData() async {
    List<Map<String, dynamic>> alertList = List<Map<String, dynamic>>.from(
        await getDataFromUrl<List<dynamic>>(
            'https://www.kosher.org.ar/api/alertas.php'));

    return List<AlertModel>.from(alertList.map((x) => AlertModel.fromJson(x)))
        .where(
          (AlertModel alertModel) => alertModel.mostrar.toLowerCase() == "s",
        )
        .toList();
  }
}
