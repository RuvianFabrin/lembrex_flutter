import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/sync/sync_repository.dart';
import '../../core/utils/platform_utils.dart';
import '../sync/sync_progress_dialog.dart';
import '../sync/sync_provider.dart';
import 'configuracoes_provider.dart';

class ConfiguracoesPage extends ConsumerStatefulWidget {
  const ConfiguracoesPage({super.key});

  @override
  ConsumerState<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends ConsumerState<ConfiguracoesPage> {
  late final TextEditingController _urlController;
  late final TextEditingController _tokenController;
  bool _mostrarToken = false;
  bool _verificando = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    _tokenController = TextEditingController();

    // Preenche controllers quando as configurações carregarem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cfg = ref.read(configuracoesProvider).valueOrNull;
      if (cfg != null) {
        _urlController.text = cfg.apiUrl;
        _tokenController.text = cfg.apiToken;
      }
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _salvar(int intervalo) async {
    await ref.read(configuracoesProvider.notifier).salvar(
          apiUrl: _urlController.text.trim(),
          apiToken: _tokenController.text.trim(),
          intervaloMinutos: intervalo,
        );
    ref.read(syncServiceProvider).parar();
    ref.read(syncServiceProvider).iniciar(Duration(minutes: intervalo));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurações salvas')),
      );
    }
  }

  Future<void> _verificarConexao() async {
    setState(() => _verificando = true);
    final url = _urlController.text.trim();
    final ok = await SyncRepository(baseUrl: url).ping();
    if (!mounted) return;
    setState(() => _verificando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Conexão OK ✓' : 'Sem resposta do servidor'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _sincronizarAgora() async {
    await mostrarSyncProgressDialog(context, ref);
  }

  Future<void> _syncCompleto() async {
    // Limpa lastSyncAt para forçar download de todos os registros do servidor
    await ref.read(configuracoesProvider.notifier).limparLastSync();
    ref.read(syncServiceProvider).resetLastSync();
    if (!mounted) return;
    await mostrarSyncProgressDialog(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    final cfgAsync = ref.watch(configuracoesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        automaticallyImplyLeading: !isDesktop,
      ),
      body: cfgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (cfg) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── URL ──────────────────────────────────────────────
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL da API',
                  hintText: 'http://192.168.0.10:38080',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),

              // ── Token ─────────────────────────────────────────────
              TextField(
                controller: _tokenController,
                decoration: InputDecoration(
                  labelText: 'Token Bearer',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_mostrarToken
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setState(() => _mostrarToken = !_mostrarToken),
                  ),
                ),
                obscureText: !_mostrarToken,
              ),
              const SizedBox(height: 16),

              // ── Intervalo ─────────────────────────────────────────
              const Text('Intervalo de sincronização'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [5, 15, 30, 60].map((min) {
                  final selecionado = cfg.intervaloMinutos == min;
                  return ChoiceChip(
                    label: Text('$min min'),
                    selected: selecionado,
                    onSelected: (_) => _salvar(min),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Última sync ───────────────────────────────────────
              if (cfg.lastSyncAt != null)
                Text(
                  'Última sincronização: ${DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR').format(cfg.lastSyncAt!.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 20),

              // ── Botões ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: _verificando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_tethering_outlined),
                      label: const Text('Verificar conexão'),
                      onPressed: _verificando ? null : _verificarConexao,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.sync),
                      label: const Text('Sincronizar agora'),
                      onPressed: _sincronizarAgora,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => _salvar(cfg.intervaloMinutos),
                child: const Text('Salvar configurações'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.pin_outlined),
                label: const Text('Redefinir PIN de desbloqueio'),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/setup-pin'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.warning_amber_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Emergência',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.sync_problem_outlined),
                label: const Text('Forçar sync completo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error.withAlpha(120)),
                ),
                onPressed: _syncCompleto,
              ),
              const SizedBox(height: 4),
              Text(
                'Baixa tudo do servidor do zero. Use se os dados não estiverem aparecendo.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
