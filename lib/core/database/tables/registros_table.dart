import 'package:drift/drift.dart';

import 'categorias_table.dart';

/// Tabela principal de registros.
/// - id: timestamp em microssegundos (formato: 20240608143022123456)
/// - extras: JSON com campos extras da categoria (telefone, valor, etc.)
/// - deletado: soft delete — nunca apagar fisicamente, propagar via sync
class Registros extends Table {
  TextColumn get id => text()();
  TextColumn get categoriaId => text().references(Categorias, #id)();
  TextColumn get titulo => text().withDefault(const Constant(''))();
  TextColumn get conteudo => text().withDefault(const Constant(''))();
  TextColumn get extras => text().withDefault(const Constant('{}'))(); // JSON
  DateTimeColumn get data => dateTime().nullable()();
  DateTimeColumn get lembrete => dateTime().nullable()();
  BoolColumn get deletado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
