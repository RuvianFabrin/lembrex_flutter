import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/anexos_table.dart';

part 'anexos_dao.g.dart';

@DriftAccessor(tables: [Anexos])
class AnexosDao extends DatabaseAccessor<AppDatabase> with _$AnexosDaoMixin {
  AnexosDao(super.db);

  Future<String> inserir(AnexosCompanion entrada) async {
    await into(anexos).insert(entrada);
    return entrada.id.value;
  }

  Future<List<Anexo>> buscarPorRegistro(String registroId) {
    return (select(anexos)
          ..where((t) =>
              t.registroId.equals(registroId) &
              t.deletado.equals(false)))
        .get();
  }

  Future<void> marcarSincronizado(String id) {
    return (update(anexos)..where((t) => t.id.equals(id)))
        .write(const AnexosCompanion(sincronizado: Value(true)));
  }

  Future<void> softDelete(String id) {
    final agora = DateTime.now().toIso8601String();
    return (update(anexos)..where((t) => t.id.equals(id))).write(
      AnexosCompanion(
        deletado: const Value(true),
        updatedAt: Value(agora),
      ),
    );
  }
}
