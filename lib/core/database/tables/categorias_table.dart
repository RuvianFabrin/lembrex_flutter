import 'package:drift/drift.dart';

/// Tabela de categorias dos registros.
/// As flags determinam quais campos extras são exibidos na UI para cada categoria.
class Categorias extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text()();
  TextColumn get icone => text()(); // emoji
  BoolColumn get mostraData => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraHora => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraTelefone => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraEmail => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraValor => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraVencimento => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraMedico => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraNumeroDocumento => boolean().withDefault(const Constant(false))();
  BoolColumn get mostraPrazo => boolean().withDefault(const Constant(false))();
  IntColumn get ordem => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
