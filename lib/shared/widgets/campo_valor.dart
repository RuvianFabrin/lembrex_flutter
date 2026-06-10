import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoValor extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const CampoValor({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<CampoValor> createState() => _CampoValorState();
}

class _CampoValorState extends State<CampoValor> {
  late final _ValorFormatter _formatter;

  @override
  void initState() {
    super.initState();
    _formatter = _ValorFormatter();
    // Formata o valor inicial caso já exista (ex: "1000,00")
    final raw = widget.controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.isNotEmpty) {
      widget.controller.text = _formatter.formatDigits(raw);
      widget.controller.selection = TextSelection.collapsed(
        offset: widget.controller.text.length,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: 'Valor (R\$)',
        prefixIcon: Icon(Icons.attach_money),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [_formatter],
      onChanged: (_) => widget.onChanged(),
    );
  }
}

class _ValorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Extrai apenas dígitos do novo texto
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final formatted = formatDigits(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  /// Converte string de dígitos em formato "1.234,56"
  String formatDigits(String digits) {
    if (digits.isEmpty) return '';

    // Garante ao menos 3 dígitos (para ter "0,01")
    final padded = digits.padLeft(3, '0');

    final centavos = padded.substring(padded.length - 2);
    final inteiroPart = padded.substring(0, padded.length - 2);

    // Remove zeros à esquerda, mas mantém ao menos "0"
    final inteiroSemZero = inteiroPart.replaceFirst(RegExp(r'^0+'), '');
    final inteiro = inteiroSemZero.isEmpty ? '0' : inteiroSemZero;

    // Insere separadores de milhar
    final buffer = StringBuffer();
    int count = 0;
    for (int i = inteiro.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(inteiro[i]);
      count++;
    }
    final inteiroFormatado = buffer.toString().split('').reversed.join();

    return '$inteiroFormatado,$centavos';
  }
}
