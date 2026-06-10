import 'dart:convert';

/// Retorna a primeira linha não-vazia do documento AppFlowy, truncada em 60 chars.
/// Se o conteúdo não for JSON válido do AppFlowy, retorna o texto original truncado.
String previewConteudo(String conteudo, {int maxChars = 60}) {
  try {
    final json = jsonDecode(conteudo) as Map<String, dynamic>;
    final children = json['document']?['children'] as List<dynamic>?;
    if (children == null) return _truncar(conteudo, maxChars);
    for (final node in children) {
      final texto = _textoDoNode(node).trim();
      if (texto.isNotEmpty) return _truncar(texto, maxChars);
    }
    return '';
  } catch (_) {
    return _truncar(conteudo, maxChars);
  }
}

String _textoDoNode(dynamic node) {
  final buffer = StringBuffer();
  final data = node['data'] as Map<String, dynamic>?;
  final delta = data?['delta'] as List<dynamic>?;
  if (delta != null) {
    for (final op in delta) {
      final insert = op['insert'];
      if (insert is String) buffer.write(insert);
    }
  }
  return buffer.toString();
}

String _truncar(String texto, int max) {
  if (texto.length <= max) return texto;
  return '${texto.substring(0, max)}...';
}
