final _tagRegex = RegExp(r'#([a-zA-ZÀ-ÿ0-9_\-]+)');

List<String> extrairTags(String texto) {
  return _tagRegex
      .allMatches(texto)
      .map((m) => m.group(1)!.toLowerCase())
      .toSet()
      .toList();
}
