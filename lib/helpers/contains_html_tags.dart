bool containsHtmlTags(String input) {
  // Regular expression to match HTML tags
  // This regex looks for patterns like <tag>, </tag>, <tag attr="value">, etc.
  final RegExp htmlTagRegex = RegExp(
    r'<[^>]+>', // Matches any text inside < and >
    caseSensitive: false,
  );

  // Check if the input string contains any HTML tags
  return htmlTagRegex.hasMatch(input);
}