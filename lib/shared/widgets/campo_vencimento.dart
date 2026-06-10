import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampoVencimento extends StatelessWidget {
  final DateTime? valor;
  final ValueChanged<DateTime?> onChanged;

  const CampoVencimento({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy', 'pt_BR');
    final vencido = valor != null && valor!.isBefore(DateTime.now());
    final cor = vencido
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Vencimento', style: TextStyle(color: cor)),
      subtitle: Text(
        valor != null ? fmt.format(valor!) : 'Não definido',
        style: TextStyle(color: vencido ? cor : null),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (vencido)
            Icon(Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error, size: 18),
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
