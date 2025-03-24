import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:kosher_ar/helpers/build_base64_image.dart';
import 'package:kosher_ar/helpers/clean_html.dart';
import 'package:kosher_ar/helpers/show_image_pitch_to_zoom.dart';
import 'package:kosher_ar/models/alert_model.dart';
import 'package:kosher_ar/services/alerts_service.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
      ),
      body: FutureBuilder<List<AlertModel>>(
        future: AlertsService().getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Column(
                      children: [
                        Text(
                          snapshot.data![index].nombre,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        HtmlWidget(
                          cleanHtml(
                            (snapshot.data![index].descripcion),
                          ),
                          customWidgetBuilder: (element) {
                            if (element.localName == 'img') {
                              return GestureDetector(
                                onTap: () => showImagePitchToZoom(
                                    context, element.attributes['src']!),
                                child: buildBase64Image(
                                    element.attributes['src']!),
                              );
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Fecha: ${snapshot.data![index].fechaUltimaModificacion.toLocal().toString().split(' ')[0]}'),
                          Text(
                              'Hora: ${snapshot.data![index].fechaUltimaModificacion.toLocal().toString().split(' ')[1].split('.')[0]}'),
                        ],
                      ),
                    ),
                  ),
                  const Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }
}
