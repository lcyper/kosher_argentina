bool isHtmlEmpty(String htmlString) {
  // Eliminar etiquetas HTML y espacios
  final text = htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '') // Eliminar todas las etiquetas HTML
      .replaceAll(RegExp(r'&[^;]+;'), '') // Eliminar entidades HTML
      .replaceAll(RegExp(r'\s+'), '') // Eliminar espacios en blanco
      .trim();
  
  return text.isEmpty;
}