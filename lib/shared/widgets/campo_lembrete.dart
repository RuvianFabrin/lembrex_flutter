import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CampoLembrete extends StatelessWidget {
  final DateTime? valor;
  final ValueChanged<DateTime?> onChanged;

  const CampoLembrete({
    super.key,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Lembrete'),
      subtitle: Text(valor != null ? fmt.format(valor!) : 'Não definido'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.alarm_outlined),
            onPressed: () => _escolherDataHora(context),
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

  Future<void> _escolherDataHora(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: valor ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (data == null || !context.mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: valor != null
          ? TimeOfDay.fromDateTime(valor!)
          : TimeOfDay.now(),
    );
    if (hora == null) return;

    onChanged(DateTime(
      data.year,
      data.month,
      data.day,
      hora.hour,
      hora.minute,
    ));
  }
}
