import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampoData extends StatelessWidget {
  final String rotulo;
  final DateTime? valor;
  final ValueChanged<DateTime?> onChanged;

  const CampoData({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy', 'pt_BR');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(rotulo),
      subtitle: Text(valor != null ? fmt.format(valor!) : 'Não definida'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: valor ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) onChanged(picked);
            },
          ),
          if (valor != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => onChanged(null),
            ),
        ],
      ),
    );
  }
}
