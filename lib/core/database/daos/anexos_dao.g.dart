// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anexos_dao.dart';

// ignore_for_file: type=lint
mixin _$AnexosDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $RegistrosTable get registros => attachedDatabase.registros;
  $AnexosTable get anexos => attachedDatabase.anexos;
  AnexosDaoManager get managers => AnexosDaoManager(this);
}

class AnexosDaoManager {
  final _$AnexosDaoMixin _db;
  AnexosDaoManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$RegistrosTableTableManager get registros =>
      $$RegistrosTableTableManager(_db.attachedDatabase, _db.registros);
  $$AnexosTableTableManager get anexos =>
      $$AnexosTableTableManager(_db.attachedDatabase, _db.anexos);
}
