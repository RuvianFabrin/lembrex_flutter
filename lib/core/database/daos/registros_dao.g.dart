// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registros_dao.dart';

// ignore_for_file: type=lint
mixin _$RegistrosDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  $RegistrosTable get registros => attachedDatabase.registros;
  RegistrosDaoManager get managers => RegistrosDaoManager(this);
}

class RegistrosDaoManager {
  final _$RegistrosDaoMixin _db;
  RegistrosDaoManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
  $$RegistrosTableTableManager get registros =>
      $$RegistrosTableTableManager(_db.attachedDatabase, _db.registros);
}
