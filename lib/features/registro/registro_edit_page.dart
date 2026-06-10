import 'dart:async';
import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/auth/auth_storage.dart';
import '../../core/database/app_database.dart';
import '../configuracoes/configuracoes_provider.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/imagem_path_utils.dart';
import '../../core/utils/platform_utils.dart';
import '../../core/utils/tag_extractor.dart';
import '../../shared/widgets/campo_data.dart';
import '../../shared/widgets/campo_email.dart';
import '../../shared/widgets/campo_lembrete.dart';
import '../../shared/widgets/campo_recorrencia.dart';
import '../../shared/widgets/campo_telefone.dart';
import '../../shared/widgets/campo_valor.dart';
import '../../shared/widgets/campo_vencimento.dart';
import 'registro_provider.dart';
import 'widgets/imagem_inline_widget.dart';

class RegistroEditPage extends ConsumerStatefulWidget {
  final String categoriaId;
  final String categoriaTitulo;
  final Registro? registro;

  const RegistroEditPage({
    super.key,
    required this.categoriaId,
    required this.categoriaTitulo,
    required this.registro,
  });

  @override
  ConsumerState<RegistroEditPage> createState() => _RegistroEditPageState();
}

class _RegistroEditPageState extends ConsumerState<RegistroEditPage> {
  // Controllers criados UMA ÚNICA VEZ no initState — nunca no build()
  late final TextEditingController _tituloController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _valorController;
  late final Debouncer _debouncer;

  // EditorState e scroll criados UMA ÚNICA VEZ no initState — nunca no build()
  EditorState? _editorState;
  EditorScrollController? _scrollController;
  StreamSubscription<(TransactionTime, Transaction)>? _txSub;

  late String _id;
  late Map<String, dynamic> _extras;
  DateTime? _data;
  DateTime? _lembrete;
  DateTime? _vencimento;
  String? _recorrencia;
  Categoria? _categoria;
  bool _salvo = true;

  // Nota Livre (CAT001) usa editor rico; demais categorias usam editor simples
  bool get _usarEditorRico => widget.categoriaId == 'CAT001';

  @override
  void initState() {
    super.initState();

    final r = widget.registro;
    _id = r?.id ?? '';
    _extras = r != null ? jsonDecode(r.extras) as Map<String, dynamic> : {};
    _data = r?.data;
    _lembrete = r?.lembrete;
    _vencimento = _extras['vencimento'] != null
        ? DateTime.tryParse(_extras['vencimento'] as String)
        : null;
    _recorrencia = _extras['recorrencia'] as String?;

    _tituloController = TextEditingController(text: r?.titulo ?? '');
    _telefoneController =
        TextEditingController(text: _extras['telefone'] as String? ?? '');
    _emailController =
        TextEditingController(text: _extras['email'] as String? ?? '');
    _valorController =
        TextEditingController(text: _extras['valor'] as String? ?? '');

    _debouncer = Debouncer();

    // Inicializa EditorState de forma assíncrona para resolver paths locais de imagens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cfg = ref.read(configuracoesProvider).valueOrNull;
      final state = await _criarEditorState(r?.conteudo, baseUrl: cfg?.apiUrl);
      if (!mounted) return;
      _scrollController = EditorScrollController(editorState: state);
      state.selectionMenuItems = standardSelectionMenuItems;
      _txSub = state.transactionStream.listen((_) => _agendarSave());
      setState(() => _editorState = state);
      await _carregarCategoria();

      // Migra imagens para formato portável srv:// em background:
      // - paths locais → faz upload e converte para srv://
      // - URLs absolutas http(s)://*/uploads/ → converte para srv://
      if (_id.isNotEmpty && r?.conteudo != null) {
        _migrarImagensLegadas(r!.conteudo);
      }
    });
  }

  Future<EditorState> _criarEditorState(String? conteudoJson, {String? baseUrl}) async {
    if (conteudoJson != null && conteudoJson.isNotEmpty) {
      try {
        var json = jsonDecode(conteudoJson) as Map<String, dynamic>;
        if (json.isNotEmpty) {
          // Resolve srv:// → URL absoluta e local:// → path absoluto
          json = await resolverPathsLocais(json, baseUrl: baseUrl);
          final state = EditorState(document: Document.fromJson(json));
          // Garante ao menos um nó — clamp() do serviço de seleção crasha com lista vazia
          if (state.document.root.children.isNotEmpty) return state;
        }
      } catch (_) {}
    }
    // Sempre com um parágrafo inicial para evitar crash no onTapDown
    return EditorState.blank(withInitialText: true);
  }

  /// Migra imagens para o formato portável srv://.
  /// Roda silenciosamente em background — não bloqueia a UI.
  Future<void> _migrarImagensLegadas(String conteudoJson) async {
    try {
      final cfg = ref.read(configuracoesProvider).valueOrNull;
      if (cfg == null) return;
      final token = await AuthStorage.lerToken();
      if (token == null) return;

      final docJson = jsonDecode(conteudoJson) as Map<String, dynamic>;
      final (jsonAtualizado, foiModificado) = await migrarPathsLegados(
        docJson: docJson,
        baseUrl: cfg.apiUrl,
        token: token,
        registroId: _id,
      );

      if (!foiModificado || !mounted) return;

      // Salva o conteúdo atualizado com URLs do servidor
      await ref.read(registroNotifierProvider.notifier).salvar(
            id: _id,
            categoriaId: widget.categoriaId,
            titulo: _tituloController.text,
            conteudo: jsonEncode(jsonAtualizado),
            extras: _extras,
            data: _data,
            lembrete: _lembrete,
          );
    } catch (_) {}
  }

  Future<void> _carregarCategoria() async {
    final db = ref.read(databaseProvider);
    final cat = await db.categoriasDao.buscarPorId(widget.categoriaId);
    if (mounted) setState(() => _categoria = cat);
  }

  void _agendarSave() {
    if (mounted) setState(() => _salvo = false);
    _debouncer(() => _salvarLocal());
  }

  String _conteudoAtual() {
    return jsonEncode(_editorState!.document.toJson());
  }

  Future<void> _salvarLocal() async {
    if (_editorState == null) return;
    _sincronizarExtras();

    // Extrai tags do texto plano do editor
    final textoPlano = _extrairTextoPlano();
    final tags = extrairTags(textoPlano);
    if (tags.isEmpty) {
      _extras.remove('tags');
    } else {
      _extras['tags'] = tags;
    }

    final novoId = await ref.read(registroNotifierProvider.notifier).salvar(
          id: _id.isEmpty ? null : _id,
          categoriaId: widget.categoriaId,
          titulo: _tituloController.text,
          conteudo: _conteudoAtual(),
          extras: _extras,
          data: _data,
          lembrete: _lembrete,
        );
    if (_id.isEmpty) _id = novoId;

    // Agenda ou cancela notificação conforme campo lembrete
    if (!isDesktop) {
      if (_lembrete != null) {
        await NotificationService.agendar(
          registroId: _id,
          titulo: _tituloController.text.isNotEmpty
              ? _tituloController.text
              : 'Lembrete',
          corpo: widget.categoriaTitulo,
          dataHora: _lembrete!,
        );
      } else {
        await NotificationService.cancelar(_id);
      }
    }

    // setState apenas para o indicador — não afeta o editor
    if (mounted) setState(() => _salvo = true);
  }

  String _extrairTextoPlano() {
    final buffer = StringBuffer();
    for (final node in _editorState!.document.root.children) {
      final delta = node.delta;
      if (delta != null) {
        buffer.writeln(delta.toPlainText());
      }
    }
    return buffer.toString();
  }

  void _sincronizarExtras() {
    if (_telefoneController.text.isNotEmpty) {
      _extras['telefone'] = _telefoneController.text;
    } else {
      _extras.remove('telefone');
    }
    if (_emailController.text.isNotEmpty) {
      _extras['email'] = _emailController.text;
    } else {
      _extras.remove('email');
    }
    if (_valorController.text.isNotEmpty) {
      _extras['valor'] = _valorController.text;
    } else {
      _extras.remove('valor');
    }
    if (_vencimento != null) {
      _extras['vencimento'] = _vencimento!.toIso8601String();
    } else {
      _extras.remove('vencimento');
    }
    if (_recorrencia != null) {
      _extras['recorrencia'] = _recorrencia;
    } else {
      _extras.remove('recorrencia');
    }
  }

  @override
  void dispose() {
    _txSub?.cancel();
    // Flush garante que a última edição não se perde ao fechar
    _debouncer.flush();
    _salvarLocal();
    _tituloController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _valorController.dispose();
    _debouncer.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        if (isDesktop)
          const SingleActivator(LogicalKeyboardKey.escape): () =>
              Navigator.maybePop(context),
      },
      child: Focus(
        autofocus: isDesktop,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.categoriaTitulo.isEmpty
                ? 'Editar'
                : widget.categoriaTitulo),
            automaticallyImplyLeading: !isDesktop,
            leading: isDesktop
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.maybePop(context),
                  )
                : null,
            actions: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _salvo
                    ? const Icon(Icons.check_circle_outline,
                        key: ValueKey('salvo'), color: Colors.green)
                    : const SizedBox.shrink(key: ValueKey('salvando')),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _editorState == null || _scrollController == null
              ? const Center(child: CircularProgressIndicator())
              : _Formulario(
            tituloController: _tituloController,
            telefoneController: _telefoneController,
            emailController: _emailController,
            valorController: _valorController,
            editorState: _editorState!,
            scrollController: _scrollController!,
            usarEditorRico: _usarEditorRico,
            registroId: _id,
            data: _data,
            lembrete: _lembrete,
            vencimento: _vencimento,
            recorrencia: _recorrencia,
            categoria: _categoria,
            onChanged: _agendarSave,
            onDataChanged: (v) {
              _data = v;
              _agendarSave();
            },
            onLembreteChanged: (v) {
              _lembrete = v;
              _agendarSave();
            },
            onVencimentoChanged: (v) {
              _vencimento = v;
              _agendarSave();
            },
            onRecorrenciaChanged: (v) {
              _recorrencia = v;
              _agendarSave();
            },
          ),
        ),
      ),
    );
  }
}

// ─── Formulário separado para evitar rebuild do Scaffold inteiro ──────────────
//
// Regra de layout: o AppFlowyEditor precisa de altura FINITA — o Overlay interno
// do pacote falha com height=infinity. Por isso o editor NUNCA entra em
// SingleChildScrollView. A estratégia é:
//
//  Desktop + ≥3 campos extras → Row: [Expanded(editor) | painel 240px]
//  Mobile  + campos extras    → DefaultTabController: aba "Conteúdo" | aba "Detalhes"
//  Sem campos extras          → editor ocupa tudo (Column + Expanded)

class _Formulario extends StatelessWidget {
  final TextEditingController tituloController;
  final TextEditingController telefoneController;
  final TextEditingController emailController;
  final TextEditingController valorController;
  final EditorState editorState;
  final EditorScrollController scrollController;
  final bool usarEditorRico;
  final String registroId;
  final DateTime? data;
  final DateTime? lembrete;
  final DateTime? vencimento;
  final String? recorrencia;
  final Categoria? categoria;
  final VoidCallback onChanged;
  final ValueChanged<DateTime?> onDataChanged;
  final ValueChanged<DateTime?> onLembreteChanged;
  final ValueChanged<DateTime?> onVencimentoChanged;
  final ValueChanged<String?> onRecorrenciaChanged;

  const _Formulario({
    required this.tituloController,
    required this.telefoneController,
    required this.emailController,
    required this.valorController,
    required this.editorState,
    required this.scrollController,
    required this.usarEditorRico,
    required this.registroId,
    required this.data,
    required this.lembrete,
    required this.vencimento,
    required this.recorrencia,
    required this.categoria,
    required this.onChanged,
    required this.onDataChanged,
    required this.onLembreteChanged,
    required this.onVencimentoChanged,
    required this.onRecorrenciaChanged,
  });

  int get _qtdCamposExtras {
    if (categoria == null) return 0;
    return [
      categoria!.mostraData,
      categoria!.mostraHora ||
          categoria!.mostraVencimento ||
          categoria!.mostraPrazo,
      categoria!.mostraTelefone,
      categoria!.mostraEmail,
      categoria!.mostraValor,
      categoria!.mostraVencimento,
      categoria!.mostraPrazo,
      categoria!.mostraMedico,
    ].where((v) => v).length;
  }

  bool get _temCamposExtras => _qtdCamposExtras > 0;

  bool get _usarLayoutColunas => isDesktop && _qtdCamposExtras >= 3;

  Widget _buildEditorWidget({bool expandido = true}) => _EditorWidget(
        tituloController: tituloController,
        editorState: editorState,
        scrollController: scrollController,
        usarEditorRico: usarEditorRico,
        registroId: registroId,
        onTituloChanged: onChanged,
        expandido: expandido,
      );

  Widget _buildCamposExtras() => _CamposExtras(
        categoria: categoria!,
        data: data,
        lembrete: lembrete,
        vencimento: vencimento,
        recorrencia: recorrencia,
        telefoneController: telefoneController,
        emailController: emailController,
        valorController: valorController,
        onChanged: onChanged,
        onDataChanged: onDataChanged,
        onLembreteChanged: onLembreteChanged,
        onVencimentoChanged: onVencimentoChanged,
        onRecorrenciaChanged: onRecorrenciaChanged,
      );

  @override
  Widget build(BuildContext context) {
    // Nota Livre: editor ocupa tudo, sem abas nem campos
    if (usarEditorRico) {
      if (_usarLayoutColunas) {
        // Desktop com campos (não é Nota Livre, mas por precaução)
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildEditorWidget()),
            const VerticalDivider(width: 1, thickness: 1),
            SizedBox(
              width: 240,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildCamposExtras(),
              ),
            ),
          ],
        );
      }
      return _buildEditorWidget();
    }

    // Outras categorias: desktop com ≥3 campos → layout em coluna
    if (_usarLayoutColunas) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildEditorWidget()),
          const VerticalDivider(width: 1, thickness: 1),
          SizedBox(
            width: 240,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildCamposExtras(),
            ),
          ),
        ],
      );
    }

    // Outras categorias (mobile/desktop simples): editor compacto + campos em scroll
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Editor com altura fixa — SizedBox garante constraints finitas para o Overlay
          _buildEditorWidget(expandido: false),
          if (_temCamposExtras) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCamposExtras(),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─── Widget do editor (título + AppFlowyEditor) ───────────────────────────────

class _EditorWidget extends StatelessWidget {
  final TextEditingController tituloController;
  final EditorState editorState;
  final EditorScrollController scrollController;
  final bool usarEditorRico;
  final String registroId;
  final VoidCallback onTituloChanged;
  // false = altura fixa (dentro de SingleChildScrollView); true = Expanded
  final bool expandido;

  const _EditorWidget({
    required this.tituloController,
    required this.editorState,
    required this.scrollController,
    required this.usarEditorRico,
    required this.registroId,
    required this.onTituloChanged,
    this.expandido = true,
  });

  EditorStyle _buildStyle(Color textColor) {
    final config = TextStyleConfiguration(
      text: GoogleFonts.dmSans(fontSize: 16, height: 1.5, color: textColor),
      bold: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
      italic: GoogleFonts.dmSans(fontStyle: FontStyle.italic),
      underline: GoogleFonts.dmSans(decoration: TextDecoration.underline),
      strikethrough: GoogleFonts.dmSans(decoration: TextDecoration.lineThrough),
    );
    if (isDesktop) {
      return EditorStyle.desktop(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        textStyleConfiguration: config,
      );
    }
    return EditorStyle.mobile(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      textStyleConfiguration: config,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final editorStyle = _buildStyle(textColor);

    final appFlowyEditor = AppFlowyEditor(
      editorState: editorState,
      editorScrollController: scrollController,
      editorStyle: editorStyle,
      blockComponentBuilders: standardBlockComponentBuilderMap,
      commandShortcutEvents: standardCommandShortcutEvents,
      characterShortcutEvents: standardCharacterShortcutEvents,
    );

    Widget editorArea;
    if (isDesktop) {
      editorArea = FloatingToolbar(
        items: [
          paragraphItem,
          ...headingItems,
          placeholderItem,
          ...markdownFormatItems,
          quoteItem,
          bulletedListItem,
          numberedListItem,
        ],
        editorState: editorState,
        editorScrollController: scrollController,
        textDirection: TextDirection.ltr,
        child: appFlowyEditor,
      );
    } else {
      // O AppFlowyEditor mobile precisa de Expanded para ter altura finita.
      // MobileFloatingToolbar exibe copy/cut/paste ao selecionar texto.
      editorArea = MobileToolbarV2(
        toolbarItems: [
          textDecorationMobileToolbarItemV2,
          headingMobileToolbarItem,
          listMobileToolbarItem,
          blocksMobileToolbarItem,
        ],
        editorState: editorState,
        child: Column(
          children: [
            Expanded(
              child: MobileFloatingToolbar(
                editorState: editorState,
                editorScrollController: scrollController,
                toolbarBuilder: (context, anchor, closeToolbar) =>
                    AdaptiveTextSelectionToolbar.editable(
                  clipboardStatus: ClipboardStatus.pasteable,
                  onCopy: () {
                    copyCommand.execute(editorState);
                    closeToolbar();
                  },
                  onCut: () => cutCommand.execute(editorState),
                  onPaste: () => pasteCommand.execute(editorState),
                  onSelectAll: () => selectAllCommand.execute(editorState),
                  onLiveTextInput: null,
                  onLookUp: null,
                  onSearchWeb: null,
                  onShare: null,
                  anchors: TextSelectionToolbarAnchors(
                    primaryAnchor: anchor,
                  ),
                ),
                child: appFlowyEditor,
              ),
            ),
          ],
        ),
      );
    }

    final tituloField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: tituloController,
        decoration: const InputDecoration(
          hintText: 'Título',
          border: InputBorder.none,
        ),
        style: theme.textTheme.titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
        maxLines: null,
        onChanged: (_) => onTituloChanged(),
        textCapitalization: TextCapitalization.sentences,
      ),
    );

    if (expandido) {
      // Nota Livre ou desktop com Row: editor ocupa toda a altura disponível
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tituloField,
          const Divider(height: 1),
          if (usarEditorRico) ...[
            ImagemInlineWidget(editorState: editorState, registroId: registroId),
            const Divider(height: 1),
          ],
          Expanded(child: editorArea),
        ],
      );
    }

    // Outras categorias dentro de SingleChildScrollView: altura fixa
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        tituloField,
        const Divider(height: 1),
        SizedBox(height: 300, child: editorArea),
      ],
    );
  }
}

// ─── Campos extras por categoria ─────────────────────────────────────────────

class _CamposExtras extends StatelessWidget {
  final Categoria categoria;
  final DateTime? data;
  final DateTime? lembrete;
  final DateTime? vencimento;
  final String? recorrencia;
  final TextEditingController telefoneController;
  final TextEditingController emailController;
  final TextEditingController valorController;
  final VoidCallback onChanged;
  final ValueChanged<DateTime?> onDataChanged;
  final ValueChanged<DateTime?> onLembreteChanged;
  final ValueChanged<DateTime?> onVencimentoChanged;
  final ValueChanged<String?> onRecorrenciaChanged;

  const _CamposExtras({
    required this.categoria,
    required this.data,
    required this.lembrete,
    required this.vencimento,
    required this.recorrencia,
    required this.telefoneController,
    required this.emailController,
    required this.valorController,
    required this.onChanged,
    required this.onDataChanged,
    required this.onLembreteChanged,
    required this.onVencimentoChanged,
    required this.onRecorrenciaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (categoria.mostraData) ...[
          CampoData(rotulo: 'Data', valor: data, onChanged: onDataChanged),
          const SizedBox(height: 8),
        ],
        if (categoria.mostraHora ||
            categoria.mostraVencimento ||
            categoria.mostraPrazo) ...[
          CampoLembrete(valor: lembrete, onChanged: onLembreteChanged),
          const SizedBox(height: 8),
        ],
        if (categoria.mostraTelefone) ...[
          CampoTelefone(controller: telefoneController, onChanged: onChanged),
          const SizedBox(height: 8),
        ],
        if (categoria.mostraEmail) ...[
          CampoEmail(controller: emailController, onChanged: onChanged),
          const SizedBox(height: 8),
        ],
        if (categoria.mostraValor) ...[
          CampoValor(controller: valorController, onChanged: onChanged),
          const SizedBox(height: 8),
        ],
        if (categoria.mostraVencimento) ...[
          CampoVencimento(valor: vencimento, onChanged: onVencimentoChanged),
          const SizedBox(height: 8),
        ],
        if (categoria.mostraPrazo) ...[
          CampoRecorrencia(valor: recorrencia, onChanged: onRecorrenciaChanged),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
