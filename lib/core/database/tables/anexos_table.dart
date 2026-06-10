import 'package:drift/drift.dart';

import 'registros_table.dart';

/// Armazena referências a arquivos (imagens) vinculados a um registro.
/// O arquivo físico fica em getApplicationDocumentsDirectory()/anexos/<id>.<ext>.
/// Nunca entra no fluxo de sync JSON — upload separado via multipart.
class Anexos extends Table {
  TextColumn get id => text()();
  TextColumn get registroId => text().references(Registros, #id)();
  TextColumn get tipo => text().withDefault(const Constant('imagem'))();
  TextColumn get nomeArquivo => text()();
  TextColumn get caminhoLocal => text()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get tamanhoBytes => integer().nullable()();
  BoolColumn get sincronizado =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get deletado => boolean().withDefault(const Constant(false))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}
