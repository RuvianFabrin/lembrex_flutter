import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/platform_utils.dart';
import '../sync/sync_provider.dart';
import 'registro_edit_page.dart';
import '../../core/utils/conteudo_preview.dart';
import 'registro_provider.dart';

class RegistroListPage extends ConsumerStatefulWidget {
  final String categoriaId;
  final String titulo;

  const RegistroListPage({
    super.key,
    required this.categoriaId,
    required this.titulo,
  });

  @override
  ConsumerState<RegistroListPage> createState() => _RegistroListPageState();
}

class _RegistroListPageState extends ConsumerState<RegistroListPage> {
  final _buscaController = TextEditingController();
  late final Debouncer _buscaDebouncer;
  String _queryAtual = '';

  @override
  void initState() {
    super.initState();
    _buscaDebouncer = Debouncer(delay: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _buscaController.dispose();
    _buscaDebouncer.dispose();
    super.dispose();
  }

  void _onBuscaChanged(String valor) {
    _buscaDebouncer(
        () => setState(() => _queryAtual = valor.trim()));
  }

  void _abrirEdicao(BuildContext context, Registro? registro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistroEditPage(
          categoriaId: widget.categoriaId,
          categoriaTitulo: widget.titulo,
          registro: registro,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        automaticallyImplyLeading: !isDesktop,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _buscaController,
              onChanged: _onBuscaChanged,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Buscar notas, tags, campos...',
                prefixIcon: Icon(Icons.search,
                    color: cs.onSurfaceVariant, size: 20),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _queryAtual.isEmpty
                ? _ListaStream(
                    categoriaId: widget.categoriaId,
                    titulo: widget.titulo,
                    onAbrirEdicao: _abrirEdicao,
                  )
                : _ListaBusca(
                    query: _queryAtual,
                    onAbrirEdicao: _abrirEdicao,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirEdicao(context, null),
        tooltip: 'Novo registro',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Lista reativa (stream) — exibida quando não há query de busca
class _ListaStream extends ConsumerWidget {
  final String categoriaId;
  final String titulo;
  final void Function(BuildContext, Registro?) onAbrirEdicao;

  const _ListaStream({
    required this.categoriaId,
    required this.titulo,
    required this.onAbrirEdicao,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(registrosPorCategoriaProvider(categoriaId));
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (lista) => lista.isEmpty
          ? _EstadoVazio(
              categoriaId: categoriaId,
              titulo: titulo,
            )
          : RefreshIndicator(
              onRefresh: () async {
                final service = ref.read(syncServiceProvider);
                await service.sincronizar();
                if (service.ultimoErro != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sync: ${service.ultimoErro}')),
                  );
                }
              },
              child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, i) =>
                    _ItemRegistro(registro: lista[i], ref: ref),
              ),
            ),
    );
  }
}

// Lista de busca — resultado de query no DAO
class _ListaBusca extends ConsumerWidget {
  final String query;
  final void Function(BuildContext, Registro?) onAbrirEdicao;

  const _ListaBusca({required this.query, required this.onAbrirEdicao});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.read(databaseProvider).registrosDao;
    return FutureBuilder<List<Registro>>(
      future: dao.buscar(query),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final lista = snap.data ?? [];
        if (lista.isEmpty) {
          return Center(
            child: Text('Nenhum resultado para "$query"',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          );
        }
        return ListView.builder(
          itemCount: lista.length,
          itemBuilder: (context, i) =>
              _ItemRegistro(registro: lista[i], ref: ref),
        );
      },
    );
  }
}

class _ItemRegistro extends StatelessWidget {
  final Registro registro;
  final WidgetRef ref;

  const _ItemRegistro({required this.registro, required this.ref});

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir registro?'),
        content: const Text('Esta ação pode ser revertida via sincronização.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmar == true) {
      ref.read(registroNotifierProvider.notifier).deletar(registro.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempo = timeago.format(registro.updatedAt, locale: 'pt_BR');
    final extras = jsonDecode(registro.extras) as Map<String, dynamic>;

    return Dismissible(
      key: ValueKey(registro.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Excluir registro?'),
          content: const Text('Esta ação pode ser revertida via sincronização.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Excluir')),
          ],
        ),
      ),
      onDismissed: (_) =>
          ref.read(registroNotifierProvider.notifier).deletar(registro.id),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RegistroEditPage(
              categoriaId: registro.categoriaId,
              categoriaTitulo: '',
              registro: registro,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      registro.titulo.isEmpty ? '(sem título)' : registro.titulo,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    tempo,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (isDesktop) ...[
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: IconButton.filled(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .errorContainer,
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onErrorContainer,
                        ),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Excluir',
                        onPressed: () => _confirmarExclusao(context),
                      ),
                    ),
                  ],
                ],
              ),
              if (registro.conteudo.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  previewConteudo(registro.conteudo),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
              _ChipsExtras(registro: registro, extras: extras),
              const SizedBox(height: 12),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipsExtras extends StatelessWidget {
  final Registro registro;
  final Map<String, dynamic> extras;

  const _ChipsExtras({required this.registro, required this.extras});

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    final fmtData = DateFormat('dd/MM/yyyy', 'pt_BR');
    final fmtHora = DateFormat("dd/MM 'às' HH:mm", 'pt_BR');
    final cs = Theme.of(context).colorScheme;

    // Data do registro
    if (registro.data != null) {
      chips.add(_Chip(
        icon: Icons.calendar_today_outlined,
        label: fmtData.format(registro.data!),
      ));
    }

    // Lembrete
    if (registro.lembrete != null) {
      final vencido = registro.lembrete!.isBefore(DateTime.now());
      chips.add(_Chip(
        icon: Icons.alarm_outlined,
        label: fmtHora.format(registro.lembrete!),
        color: vencido ? cs.error : null,
      ));
    }

    // Telefone
    final tel = extras['telefone'] as String?;
    if (tel != null && tel.isNotEmpty) {
      chips.add(_Chip(icon: Icons.phone_outlined, label: tel));
    }

    // Email
    final email = extras['email'] as String?;
    if (email != null && email.isNotEmpty) {
      chips.add(_Chip(icon: Icons.email_outlined, label: email));
    }

    // Valor
    final valor = extras['valor'] as String?;
    if (valor != null && valor.isNotEmpty) {
      chips.add(_Chip(icon: Icons.attach_money, label: 'R\$ $valor'));
    }

    // Vencimento
    final vencStr = extras['vencimento'] as String?;
    if (vencStr != null) {
      final venc = DateTime.tryParse(vencStr);
      if (venc != null) {
        final vencido = venc.isBefore(DateTime.now());
        chips.add(_Chip(
          icon: vencido ? Icons.warning_amber_rounded : Icons.event_outlined,
          label: fmtData.format(venc),
          color: vencido ? cs.error : null,
        ));
      }
    }

    // Recorrência
    final rec = extras['recorrencia'] as String?;
    if (rec != null && rec.isNotEmpty) {
      chips.add(_Chip(icon: Icons.repeat, label: rec));
    }

    final tags = List<String>.from(extras['tags'] as List? ?? []);

    if (chips.isEmpty && tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          ...chips,
          ...tags.map((tag) => _TagChip(tag: tag)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _Chip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveColor = color ?? cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? cs.primary).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (color ?? cs.outlineVariant),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: effectiveColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: effectiveColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.5),
      ),
      child: Text(
        '#$tag',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 12,
            ),
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  final String categoriaId;
  final String titulo;

  const _EstadoVazio({required this.categoriaId, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Nenhuma anotação ainda'),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Criar primeiro'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegistroEditPage(
                  categoriaId: categoriaId,
                  categoriaTitulo: titulo,
                  registro: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
