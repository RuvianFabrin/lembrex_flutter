import 'package:flutter/material.dart';

class CampoRecorrencia extends StatelessWidget {
  final String? valor;
  final ValueChanged<String?> onChanged;

  const CampoRecorrencia({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  static const _opcoes = [
    ('diario', 'Diário'),
    ('semanal', 'Semanal'),
    ('mensal', 'Mensal'),
    ('anual', 'Anual'),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: valor,
      decoration: const InputDecoration(
        labelText: 'Recorrência',
        prefixIcon: Icon(Icons.repeat),
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(value: null, child: Text('Nenhuma')),
        ..._opcoes.map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2))),
      ],
      onChanged: onChanged,
    );
  }
}
