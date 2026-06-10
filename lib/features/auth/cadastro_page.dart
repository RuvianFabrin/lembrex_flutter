import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../core/auth/auth_storage.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmacaoController = TextEditingController();
  final _codigoController = TextEditingController();
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmacaoController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:38080';
      // Código convite: digitado pelo usuário ou pode ser lido de .env via
      // dotenv.env['INVITE_CODE'] se preferir hardcoded sem expor na UI.
      final inviteCode = _codigoController.text.trim().isNotEmpty
          ? _codigoController.text.trim()
          : (dotenv.env['INVITE_CODE'] ?? '');

      final resp = await http
          .post(
            Uri.parse('$baseUrl/api/auth/cadastro'),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Client': 'lembrex-flutter/1.0',
              'X-Invite-Code': inviteCode,
            },
            body: jsonEncode({
              'nome': _nomeController.text.trim(),
              'email': _emailController.text.trim(),
              'senha': _senhaController.text,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        final usuario = data['usuario'] as Map<String, dynamic>;
        await AuthStorage.salvarSessao(token, usuario);
        if (!mounted) return;
        // Cadastro novo — PIN nunca foi definido, vai direto para setup
        Navigator.of(context).pushReplacementNamed('/setup-pin', arguments: '/lock');
      } else {
        final data = jsonDecode(resp.body) as Map<String, dynamic>?;
        setState(
          () => _erro = data?['mensagem'] as String? ?? 'Erro ao criar conta.',
        );
      }
    } catch (e) {
      if (mounted) setState(() => _erro = 'Erro de conexão. Verifique a rede.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Criar conta',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe o e-mail' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 6)
                            ? 'Mínimo 6 caracteres'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmacaoController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v != _senhaController.text
                        ? 'As senhas não coincidem'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(
                      labelText: 'Código de convite',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Informe o código' : null,
                  ),
                  if (_erro != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _erro!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  _carregando
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton(
                          onPressed: _cadastrar,
                          child: const Text('Criar conta'),
                        ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushReplacementNamed('/login'),
                    child: const Text('Já tenho conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
