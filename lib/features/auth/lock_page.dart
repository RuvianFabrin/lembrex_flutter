import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/auth/auth_storage.dart';
import '../../core/auth/biometria_service.dart';
import '../../core/utils/platform_utils.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final _bio = BiometriaService();
  final _pinController = TextEditingController();
  bool _mostrarCampoPin = false;
  bool _carregando = false;
  String? _erro;
  String? _email;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _verificarSessao());
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verificarSessao() async {
    final token = await AuthStorage.lerToken();
    if (!mounted) return;
    if (token == null) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }
    final email = await AuthStorage.lerEmail();
    if (!mounted) return;
    setState(() => _email = email);

    // Se não há PIN definido (login em conta existente), entra direto
    final temPin = await AuthStorage.pinDefinido();
    if (!mounted) return;
    if (!temPin) {
      _navegarParaDashboard();
      return;
    }
    _tentarDesbloquear();
  }

  Future<void> _tentarDesbloquear() async {
    if (isDesktop && Platform.isLinux) {
      setState(() => _mostrarCampoPin = true);
      return;
    }

    setState(() => _carregando = true);
    final ok = await _bio.autenticar();
    if (!mounted) return;
    setState(() => _carregando = false);

    if (ok) {
      _navegarParaDashboard();
    }
  }

  Future<void> _validarPin() async {
    final pin = _pinController.text;
    if (pin.isEmpty) return;

    final ok = await AuthStorage.validarPin(pin);
    if (!mounted) return;
    if (ok) {
      _navegarParaDashboard();
    } else {
      _pinController.clear();
      setState(() => _erro = 'PIN incorreto.');
    }
  }

  void _navegarParaDashboard() {
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lembrex',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                  textAlign: TextAlign.center,
                ),
                if (_email != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _email!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 48),
                if (_mostrarCampoPin) ...[
                  TextField(
                    controller: _pinController,
                    autofocus: true,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'PIN',
                      errorText: _erro,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() => _erro = null),
                    onSubmitted: (_) => _validarPin(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _validarPin,
                    child: const Text('Desbloquear'),
                  ),
                ] else ...[
                  if (_carregando)
                    const Center(child: CircularProgressIndicator())
                  else
                    FilledButton.icon(
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Desbloquear'),
                      onPressed: _tentarDesbloquear,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
