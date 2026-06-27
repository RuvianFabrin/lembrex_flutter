import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/registros_table.dart';

part 'registros_dao.g.dart';

@DriftAccessor(tables: [Registros])
class RegistrosDao extends DatabaseAccessor<AppDatabase>
    with _$RegistrosDaoMixin {
  RegistrosDao(super.db);

  Future<List<Registro>> listarPorCategoria(String categoriaId) =>
      (select(registros)
            ..where((t) =>
                t.categoriaId.equals(categoriaId) &
                t.deletado.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .get();

  Stream<List<Registro>> watchPorCategoria(String categoriaId) =>
      (select(registros)
            ..where((t) =>
                t.categoriaId.equals(categoriaId) &
                t.deletado.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Future<Registro?> buscarPorId(String id) =>
      (select(registros)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Retorna true se o registro foi inserido ou atualizado, false se o local já era mais novo.
  Future<bool> upsert(RegistrosCompanion dados) async {
    final existing = await (select(registros)
          ..where((t) => t.id.equals(dados.id.value)))
        .getSingleOrNull();

    if (existing == null) {
      await into(registros).insert(dados);
      return true;
    }

    final remoteUpdatedAt = dados.updatedAt.present ? dados.updatedAt.value : null;
    if (remoteUpdatedAt != null && remoteUpdatedAt.isAfter(existing.updatedAt)) {
      await (update(registros)..where((t) => t.id.equals(dados.id.value)))
          .write(dados);
      return true;
    }

    return false;
  }

  Future<void> softDelete(String id) async {
    await (update(registros)..where((t) => t.id.equals(id))).write(
      RegistrosCompanion(
        deletado: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  /// Retorna registros deletados — usado para propagar soft delete no sync.
  Future<List<Registro>> listarDeletados() =>
      (select(registros)..where((t) => t.deletado.equals(true))).get();

  /// Retorna todos os registros modificados após [desde] — usado no sync push.
  Future<List<Registro>> listarModificadosApos(DateTime desde) =>
      (select(registros)..where((t) => t.updatedAt.isBiggerThanValue(desde)))
          .get();

  /// Busca full-text em título, conteúdo e extras (inclui tags via LIKE no JSON).
  Future<List<Registro>> buscar(String query) {
    if (query.isEmpty) {
      return (select(registros)
            ..where((t) => t.deletado.equals(false))
            ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
            ..limit(50))
          .get();
    }
    final q = '%$query%';
    return (select(registros)
          ..where((t) =>
              t.deletado.equals(false) &
              (t.titulo.like(q) | t.conteudo.like(q) | t.extras.like(q)))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(50))
        .get();
  }
}
