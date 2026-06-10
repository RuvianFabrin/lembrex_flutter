import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/platform_utils.dart';
import '../../core/utils/conteudo_preview.dart';
import '../../shared/widgets/status_sync_badge.dart';
import '../registro/registro_edit_page.dart';
import 'dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configura locale pt_BR uma única vez
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lembrex'),
        actions: const [SyncStatusBadge()],
      ),
      body: isDesktop ? const _DashboardDesktop() : const _DashboardMobile(),
    );
  }
}

// ─── Mobile ───────────────────────────────────────────────────────────────────

class _DashboardMobile extends ConsumerWidget {
  const _DashboardMobile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _CardRecentes(),
        SizedBox(height: 16),
        _CardEventos(),
        SizedBox(height: 16),
        _CardContatos(),
      ],
    );
  }
}

// ─── Desktop ──────────────────────────────────────────────────────────────────

class _DashboardDesktop extends StatefulWidget {
  const _DashboardDesktop();

  @override
  State<_DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<_DashboardDesktop> {
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
    _buscaDebouncer(() => setState(() => _queryAtual = valor.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
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
              ? _DashboardDesktopCards()
              : _BuscaResultados(query: _queryAtual),
        ),
      ],
    );
  }
}

class _DashboardDesktopCards extends StatelessWidget {
  const _DashboardDesktopCards();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: _CardRecentes()),
              SizedBox(width: 24),
              Expanded(child: _CardEventos()),
            ],
          ),
          const SizedBox(height: 24),
          const _CardContatos(),
        ],
      ),
    );
  }
}

class _BuscaResultados extends ConsumerWidget {
  final String query;
  const _BuscaResultados({required this.query});

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
            child: Text(
              'Nenhum resultado para "$query"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: lista.length,
          itemBuilder: (context, i) {
            final r = lista[i];
            return ListTile(
              title: Text(r.titulo.isEmpty ? '(sem título)' : r.titulo),
              subtitle: r.conteudo.isNotEmpty
                  ? Text(previewConteudo(r.conteudo),
                      maxLines: 1, overflow: TextOverflow.ellipsis)
                  : null,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegistroEditPage(
                    categoriaId: r.categoriaId,
                    categoriaTitulo: '',
                    registro: r,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Cards ────────────────────────────────────────────────────────────────────

class _CardRecentes extends ConsumerWidget {
  const _CardRecentes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(registrosRecentesProvider);
    return _DashCard(
      titulo: 'Recentes',
      icone: Icons.history,
      child: async.when(
        loading: () => const _LoadingSlot(),
        error: (e, _) => _ErroSlot(mensagem: e.toString()),
        data: (lista) => lista.isEmpty
            ? const _VazioSlot(texto: 'Nenhum registro ainda')
            : Column(
                children: lista
                    .map((r) => _ItemRegistro(registro: r))
                    .toList(),
              ),
      ),
    );
  }
}

class _CardEventos extends ConsumerWidget {
  const _CardEventos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(proximosEventosProvider);
    return _DashCard(
      titulo: 'Próximos Eventos',
      icone: Icons.calendar_today_outlined,
      child: async.when(
        loading: () => const _LoadingSlot(),
        error: (e, _) => _ErroSlot(mensagem: e.toString()),
        data: (lista) => lista.isEmpty
            ? const _VazioSlot(texto: 'Nenhum evento próximo')
            : Column(
                children: lista
                    .map((r) => _ItemRegistro(registro: r, usarData: true))
                    .toList(),
              ),
      ),
    );
  }
}

class _CardContatos extends ConsumerWidget {
  const _CardContatos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(contatosRecentesProvider);
    return _DashCard(
      titulo: 'Contatos Recentes',
      icone: Icons.person_outline,
      child: async.when(
        loading: () => const _LoadingSlot(),
        error: (e, _) => _ErroSlot(mensagem: e.toString()),
        data: (lista) => lista.isEmpty
            ? const _VazioSlot(texto: 'Nenhum contato ainda')
            : Column(
                children: lista
                    .map((r) => _ItemRegistro(registro: r))
                    .toList(),
              ),
      ),
    );
  }
}

// ─── Componentes internos ─────────────────────────────────────────────────────

class _DashCard extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Widget child;

  const _DashCard({
    required this.titulo,
    required this.icone,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 300),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(icone, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(titulo,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRegistro extends StatelessWidget {
  final Registro registro;
  final bool usarData;

  const _ItemRegistro({required this.registro, this.usarData = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final referencia = usarData ? registro.data : registro.updatedAt;
    final tempoRelativo = referencia != null
        ? timeago.format(referencia, locale: 'pt_BR')
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              registro.titulo.isEmpty ? '(sem título)' : registro.titulo,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            tempoRelativo,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _LoadingSlot extends StatelessWidget {
  const _LoadingSlot();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator.adaptive());
}

class _VazioSlot extends StatelessWidget {
  final String texto;
  const _VazioSlot({required this.texto});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
      );
}

class _ErroSlot extends StatelessWidget {
  final String mensagem;
  const _ErroSlot({required this.mensagem});

  @override
  Widget build(BuildContext context) => Text('Erro: $mensagem',
      style: TextStyle(color: Theme.of(context).colorScheme.error));
}
