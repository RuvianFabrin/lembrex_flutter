import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/id_generator.dart';

/// Stream de registros não deletados de uma categoria, ordenados por updatedAt DESC.
final registrosPorCategoriaProvider =
    StreamProvider.family<List<Registro>, String>((ref, categoriaId) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.registros)
        ..where((r) =>
            r.categoriaId.equals(categoriaId) & r.deletado.equals(false))
        ..orderBy([(r) => OrderingTerm.desc(r.updatedAt)]))
      .watch();
});

/// Notifier para operações de escrita em um registro.
class RegistroNotifier extends AsyncNotifier<Registro?> {
  @override
  Future<Registro?> build() async => null;

  Future<String> salvar({
    String? id,
    required String categoriaId,
    required String titulo,
    required String conteudo,
    Map<String, dynamic>? extras,
    DateTime? data,
    DateTime? lembrete,
  }) async {
    final db = ref.read(databaseProvider);
    final registroId = id ?? gerarId();
    final agr = agora();

    await db.into(db.registros).insertOnConflictUpdate(RegistrosCompanion(
          id: Value(registroId),
          categoriaId: Value(categoriaId),
          titulo: Value(titulo),
          conteudo: Value(conteudo),
          extras: Value(jsonEncode(extras ?? {})),
          data: Value(data),
          lembrete: Value(lembrete),
          updatedAt: Value(agr),
          createdAt: id == null ? Value(agr) : const Value.absent(),
        ));

    return registroId;
  }

  Future<void> deletar(String id) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.registros)..where((r) => r.id.equals(id))).write(
      RegistrosCompanion(
        deletado: const Value(true),
        updatedAt: Value(agora()),
      ),
    );
    // Cancela notificação pendente (apenas Android)
    if (!Platform.isLinux && !Platform.isWindows) {
      await NotificationService.cancelar(id);
    }
  }
}

final registroNotifierProvider =
    AsyncNotifierProvider<RegistroNotifier, Registro?>(RegistroNotifier.new);
