import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';

/// Últimos 5 registros atualizados (qualquer categoria, não deletados).
final registrosRecentesProvider = StreamProvider<List<Registro>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.registros)
        ..where((r) => r.deletado.equals(false))
        ..orderBy([(r) => OrderingTerm.desc(r.updatedAt)])
        ..limit(5))
      .watch();
});

/// Próximos eventos: categoria CAT002, com data >= ontem, ordenados por data crescente.
final proximosEventosProvider = StreamProvider<List<Registro>>((ref) {
  final db = ref.watch(databaseProvider);
  final ontem = DateTime.now().toUtc().subtract(const Duration(hours: 24));
  return (db.select(db.registros)
        ..where((r) =>
            r.categoriaId.equals('CAT002') &
            r.deletado.equals(false) &
            r.data.isBiggerThanValue(ontem))
        ..orderBy([(r) => OrderingTerm.asc(r.data)])
        ..limit(3))
      .watch();
});

/// Últimos 3 contatos atualizados.
final contatosRecentesProvider = StreamProvider<List<Registro>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.registros)
        ..where((r) =>
            r.categoriaId.equals('CAT003') & r.deletado.equals(false))
        ..orderBy([(r) => OrderingTerm.desc(r.updatedAt)])
        ..limit(3))
      .watch();
});
