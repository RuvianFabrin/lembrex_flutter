import 'package:flutter/material.dart';

class CampoTelefone extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const CampoTelefone({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Telefone',
        prefixIcon: Icon(Icons.phone_outlined),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      onChanged: (_) => onChanged(),
    );
  }
}
