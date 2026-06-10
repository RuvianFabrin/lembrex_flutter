import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/categorias_table.dart';

part 'categorias_dao.g.dart';

@DriftAccessor(tables: [Categorias])
class CategoriasDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriasDaoMixin {
  CategoriasDao(super.db);

  Future<List<Categoria>> listarTodas() =>
      (select(categorias)..orderBy([(t) => OrderingTerm.asc(t.ordem)])).get();

  Stream<List<Categoria>> watchTodas() =>
      (select(categorias)..orderBy([(t) => OrderingTerm.asc(t.ordem)])).watch();

  Future<Categoria?> buscarPorId(String id) =>
      (select(categorias)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> inserir(CategoriasCompanion dados) =>
      into(categorias).insert(dados);

  Future<void> atualizar(CategoriasCompanion dados) =>
      update(categorias).replace(dados);

  Future<void> deletar(String id) =>
      (delete(categorias)..where((t) => t.id.equals(id))).go();

  Future<int> contar() async {
    final count = categorias.id.count();
    final query = selectOnly(categorias)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }
}
