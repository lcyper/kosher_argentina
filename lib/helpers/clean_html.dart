String cleanHtml(String html) {
  return html
      .replaceAll('ÃƒÂ¡', 'á')
      .replaceAll('ÃƒÂ³', 'ó')
      .replaceAll('ÃƒÂ©', 'é')
      .replaceAll('ÃƒÂ', 'í')
      .replaceAll('ÃƒÂº', 'ú')
      .replaceAll('ÃƒÂ±', 'ñ')
      .replaceAll('ÃƒÂ¼', 'ü');
}
