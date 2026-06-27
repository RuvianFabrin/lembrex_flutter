import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/anexos_dao.dart';
import 'daos/categorias_dao.dart';
import 'daos/registros_dao.dart';
import 'tables/anexos_table.dart';
import 'tables/categorias_table.dart';
import 'tables/registros_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Categorias, Registros, Anexos],
  daos: [CategoriasDao, RegistrosDao, AnexosDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_abrirConexao());

  @override
  int get schemaVersion => 2;

  // Como adicionar uma coluna nova no futuro (exemplo):
  //
  //   1. Adicione o campo na tabela em tables/sua_table.dart
  //   2. Incremente schemaVersion para 2
  //   3. Adicione um bloco em onUpgrade:
  //
  //      if (from < 2) {
  //        await m.addColumn(registros, registros.novaColuna);
  //      }
  //
  //   4. Rode: dart run build_runner build --delete-conflicting-outputs
  //
  // Nunca apague um bloco antigo de migração — eles são cumulativos.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedCategorias();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(anexos);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          // Upsert garante que flags de categoria no banco sempre refletem o
          // código — útil quando o app é atualizado após o banco já existir.
          await _seedCategorias();
        },
      );

  Future<void> _seedCategorias() async {
    final _flags = [
      // id, nome, icone, mostraData, mostraHora, mostraTelefone, mostraEmail,
      // mostraValor, mostraVencimento, mostraMedico, mostraNumeroDocumento, mostraPrazo, ordem
      _CatSeed('CAT001', 'Nota Livre', '📝',
          false, false, false, false, false, false, false, false, false, 0),
      _CatSeed('CAT002', 'Evento', '📅',
          true, true, false, false, false, false, false, false, false, 1),
      _CatSeed('CAT003', 'Contato', '👤',
          false, false, true, true, false, false, false, false, false, 2),
      _CatSeed('CAT004', 'Financeiro', '💰',
          true, false, false, false, true, true, false, false, false, 3),
      _CatSeed('CAT005', 'Saúde', '❤️',
          true, true, false, false, false, false, true, false, false, 4),
      _CatSeed('CAT006', 'Documento', '📄',
          false, false, false, false, false, true, false, true, false, 5),
      _CatSeed('CAT007', 'Tarefa', '✅',
          false, false, false, false, false, false, false, false, true, 6),
      _CatSeed('CAT008', 'Aprendizado', '🎓',
          false, false, false, false, false, false, false, false, false, 7),
    ];

    for (final c in _flags) {
      final companion = CategoriasCompanion.insert(
        id: c.id,
        nome: c.nome,
        icone: c.icone,
        mostraData: Value(c.mostraData),
        mostraHora: Value(c.mostraHora),
        mostraTelefone: Value(c.mostraTelefone),
        mostraEmail: Value(c.mostraEmail),
        mostraValor: Value(c.mostraValor),
        mostraVencimento: Value(c.mostraVencimento),
        mostraMedico: Value(c.mostraMedico),
        mostraNumeroDocumento: Value(c.mostraNumeroDocumento),
        mostraPrazo: Value(c.mostraPrazo),
        ordem: Value(c.ordem),
      );
      await into(categorias).insertOnConflictUpdate(companion);
    }
  }
}

LazyDatabase _abrirConexao() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'lembrex.db'));
    return NativeDatabase.createInBackground(file);
  });
}

class _CatSeed {
  final String id, nome, icone;
  final bool mostraData, mostraHora, mostraTelefone, mostraEmail;
  final bool mostraValor, mostraVencimento, mostraMedico;
  final bool mostraNumeroDocumento, mostraPrazo;
  final int ordem;

  const _CatSeed(
    this.id,
    this.nome,
    this.icone,
    this.mostraData,
    this.mostraHora,
    this.mostraTelefone,
    this.mostraEmail,
    this.mostraValor,
    this.mostraVencimento,
    this.mostraMedico,
    this.mostraNumeroDocumento,
    this.mostraPrazo,
    this.ordem,
  );
}
