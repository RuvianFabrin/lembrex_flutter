import 'package:flutter/material.dart';

class CampoEmail extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const CampoEmail({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (_) => onChanged(),
    );
  }
}
