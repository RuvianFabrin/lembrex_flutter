import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/auth/auth_storage.dart';

class SetupPinPage extends StatefulWidget {
  /// Rota para navegar após salvar o PIN.
  /// Padrão: '/lock' (primeiro uso). Configurações passam null para pop.
  final String? rotaAposSalvar;

  const SetupPinPage({super.key, this.rotaAposSalvar = '/lock'});

  @override
  State<SetupPinPage> createState() => _SetupPinPageState();
}

class _SetupPinPageState extends State<SetupPinPage> {
  final _pinController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmacaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final pin = _pinController.text;
    final confirmacao = _confirmacaoController.text;

    if (pin.length < 4) {
      setState(() => _erro = 'O PIN deve ter pelo menos 4 dígitos.');
      return;
    }
    if (pin != confirmacao) {
      setState(() => _erro = 'Os PINs não coincidem.');
      return;
    }

    await AuthStorage.salvarPin(pin);
    if (!mounted) return;
    if (widget.rotaAposSalvar != null) {
      Navigator.of(context).pushReplacementNamed(widget.rotaAposSalvar!);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Definir PIN de desbloqueio',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Este PIN será pedido toda vez que você abrir o Lembrex.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _pinController,
                  autofocus: true,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'PIN (4–6 dígitos)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() => _erro = null),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmacaoController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Confirmar PIN',
                    border: const OutlineInputBorder(),
                    errorText: _erro,
                  ),
                  onSubmitted: (_) => _salvar(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _salvar,
                  child: const Text('Salvar PIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
