// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorias_dao.dart';

// ignore_for_file: type=lint
mixin _$CategoriasDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriasTable get categorias => attachedDatabase.categorias;
  CategoriasDaoManager get managers => CategoriasDaoManager(this);
}

class CategoriasDaoManager {
  final _$CategoriasDaoMixin _db;
  CategoriasDaoManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db.attachedDatabase, _db.categorias);
}
