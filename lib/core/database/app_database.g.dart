// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconeMeta = const VerificationMeta('icone');
  @override
  late final GeneratedColumn<String> icone = GeneratedColumn<String>(
    'icone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mostraDataMeta = const VerificationMeta(
    'mostraData',
  );
  @override
  late final GeneratedColumn<bool> mostraData = GeneratedColumn<bool>(
    'mostra_data',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_data" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraHoraMeta = const VerificationMeta(
    'mostraHora',
  );
  @override
  late final GeneratedColumn<bool> mostraHora = GeneratedColumn<bool>(
    'mostra_hora',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_hora" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraTelefoneMeta = const VerificationMeta(
    'mostraTelefone',
  );
  @override
  late final GeneratedColumn<bool> mostraTelefone = GeneratedColumn<bool>(
    'mostra_telefone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_telefone" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraEmailMeta = const VerificationMeta(
    'mostraEmail',
  );
  @override
  late final GeneratedColumn<bool> mostraEmail = GeneratedColumn<bool>(
    'mostra_email',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_email" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraValorMeta = const VerificationMeta(
    'mostraValor',
  );
  @override
  late final GeneratedColumn<bool> mostraValor = GeneratedColumn<bool>(
    'mostra_valor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_valor" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraVencimentoMeta = const VerificationMeta(
    'mostraVencimento',
  );
  @override
  late final GeneratedColumn<bool> mostraVencimento = GeneratedColumn<bool>(
    'mostra_vencimento',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_vencimento" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraMedicoMeta = const VerificationMeta(
    'mostraMedico',
  );
  @override
  late final GeneratedColumn<bool> mostraMedico = GeneratedColumn<bool>(
    'mostra_medico',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_medico" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mostraNumeroDocumentoMeta =
      const VerificationMeta('mostraNumeroDocumento');
  @override
  late final GeneratedColumn<bool> mostraNumeroDocumento =
      GeneratedColumn<bool>(
        'mostra_numero_documento',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("mostra_numero_documento" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _mostraPrazoMeta = const VerificationMeta(
    'mostraPrazo',
  );
  @override
  late final GeneratedColumn<bool> mostraPrazo = GeneratedColumn<bool>(
    'mostra_prazo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("mostra_prazo" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ordemMeta = const VerificationMeta('ordem');
  @override
  late final GeneratedColumn<int> ordem = GeneratedColumn<int>(
    'ordem',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    icone,
    mostraData,
    mostraHora,
    mostraTelefone,
    mostraEmail,
    mostraValor,
    mostraVencimento,
    mostraMedico,
    mostraNumeroDocumento,
    mostraPrazo,
    ordem,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('icone')) {
      context.handle(
        _iconeMeta,
        icone.isAcceptableOrUnknown(data['icone']!, _iconeMeta),
      );
    } else if (isInserting) {
      context.missing(_iconeMeta);
    }
    if (data.containsKey('mostra_data')) {
      context.handle(
        _mostraDataMeta,
        mostraData.isAcceptableOrUnknown(data['mostra_data']!, _mostraDataMeta),
      );
    }
    if (data.containsKey('mostra_hora')) {
      context.handle(
        _mostraHoraMeta,
        mostraHora.isAcceptableOrUnknown(data['mostra_hora']!, _mostraHoraMeta),
      );
    }
    if (data.containsKey('mostra_telefone')) {
      context.handle(
        _mostraTelefoneMeta,
        mostraTelefone.isAcceptableOrUnknown(
          data['mostra_telefone']!,
          _mostraTelefoneMeta,
        ),
      );
    }
    if (data.containsKey('mostra_email')) {
      context.handle(
        _mostraEmailMeta,
        mostraEmail.isAcceptableOrUnknown(
          data['mostra_email']!,
          _mostraEmailMeta,
        ),
      );
    }
    if (data.containsKey('mostra_valor')) {
      context.handle(
        _mostraValorMeta,
        mostraValor.isAcceptableOrUnknown(
          data['mostra_valor']!,
          _mostraValorMeta,
        ),
      );
    }
    if (data.containsKey('mostra_vencimento')) {
      context.handle(
        _mostraVencimentoMeta,
        mostraVencimento.isAcceptableOrUnknown(
          data['mostra_vencimento']!,
          _mostraVencimentoMeta,
        ),
      );
    }
    if (data.containsKey('mostra_medico')) {
      context.handle(
        _mostraMedicoMeta,
        mostraMedico.isAcceptableOrUnknown(
          data['mostra_medico']!,
          _mostraMedicoMeta,
        ),
      );
    }
    if (data.containsKey('mostra_numero_documento')) {
      context.handle(
        _mostraNumeroDocumentoMeta,
        mostraNumeroDocumento.isAcceptableOrUnknown(
          data['mostra_numero_documento']!,
          _mostraNumeroDocumentoMeta,
        ),
      );
    }
    if (data.containsKey('mostra_prazo')) {
      context.handle(
        _mostraPrazoMeta,
        mostraPrazo.isAcceptableOrUnknown(
          data['mostra_prazo']!,
          _mostraPrazoMeta,
        ),
      );
    }
    if (data.containsKey('ordem')) {
      context.handle(
        _ordemMeta,
        ordem.isAcceptableOrUnknown(data['ordem']!, _ordemMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      icone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icone'],
      )!,
      mostraData: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_data'],
      )!,
      mostraHora: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_hora'],
      )!,
      mostraTelefone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_telefone'],
      )!,
      mostraEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_email'],
      )!,
      mostraValor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_valor'],
      )!,
      mostraVencimento: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_vencimento'],
      )!,
      mostraMedico: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_medico'],
      )!,
      mostraNumeroDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_numero_documento'],
      )!,
      mostraPrazo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}mostra_prazo'],
      )!,
      ordem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ordem'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final String id;
  final String nome;
  final String icone;
  final bool mostraData;
  final bool mostraHora;
  final bool mostraTelefone;
  final bool mostraEmail;
  final bool mostraValor;
  final bool mostraVencimento;
  final bool mostraMedico;
  final bool mostraNumeroDocumento;
  final bool mostraPrazo;
  final int ordem;
  const Categoria({
    required this.id,
    required this.nome,
    required this.icone,
    required this.mostraData,
    required this.mostraHora,
    required this.mostraTelefone,
    required this.mostraEmail,
    required this.mostraValor,
    required this.mostraVencimento,
    required this.mostraMedico,
    required this.mostraNumeroDocumento,
    required this.mostraPrazo,
    required this.ordem,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['icone'] = Variable<String>(icone);
    map['mostra_data'] = Variable<bool>(mostraData);
    map['mostra_hora'] = Variable<bool>(mostraHora);
    map['mostra_telefone'] = Variable<bool>(mostraTelefone);
    map['mostra_email'] = Variable<bool>(mostraEmail);
    map['mostra_valor'] = Variable<bool>(mostraValor);
    map['mostra_vencimento'] = Variable<bool>(mostraVencimento);
    map['mostra_medico'] = Variable<bool>(mostraMedico);
    map['mostra_numero_documento'] = Variable<bool>(mostraNumeroDocumento);
    map['mostra_prazo'] = Variable<bool>(mostraPrazo);
    map['ordem'] = Variable<int>(ordem);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nome: Value(nome),
      icone: Value(icone),
      mostraData: Value(mostraData),
      mostraHora: Value(mostraHora),
      mostraTelefone: Value(mostraTelefone),
      mostraEmail: Value(mostraEmail),
      mostraValor: Value(mostraValor),
      mostraVencimento: Value(mostraVencimento),
      mostraMedico: Value(mostraMedico),
      mostraNumeroDocumento: Value(mostraNumeroDocumento),
      mostraPrazo: Value(mostraPrazo),
      ordem: Value(ordem),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      icone: serializer.fromJson<String>(json['icone']),
      mostraData: serializer.fromJson<bool>(json['mostraData']),
      mostraHora: serializer.fromJson<bool>(json['mostraHora']),
      mostraTelefone: serializer.fromJson<bool>(json['mostraTelefone']),
      mostraEmail: serializer.fromJson<bool>(json['mostraEmail']),
      mostraValor: serializer.fromJson<bool>(json['mostraValor']),
      mostraVencimento: serializer.fromJson<bool>(json['mostraVencimento']),
      mostraMedico: serializer.fromJson<bool>(json['mostraMedico']),
      mostraNumeroDocumento: serializer.fromJson<bool>(
        json['mostraNumeroDocumento'],
      ),
      mostraPrazo: serializer.fromJson<bool>(json['mostraPrazo']),
      ordem: serializer.fromJson<int>(json['ordem']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'icone': serializer.toJson<String>(icone),
      'mostraData': serializer.toJson<bool>(mostraData),
      'mostraHora': serializer.toJson<bool>(mostraHora),
      'mostraTelefone': serializer.toJson<bool>(mostraTelefone),
      'mostraEmail': serializer.toJson<bool>(mostraEmail),
      'mostraValor': serializer.toJson<bool>(mostraValor),
      'mostraVencimento': serializer.toJson<bool>(mostraVencimento),
      'mostraMedico': serializer.toJson<bool>(mostraMedico),
      'mostraNumeroDocumento': serializer.toJson<bool>(mostraNumeroDocumento),
      'mostraPrazo': serializer.toJson<bool>(mostraPrazo),
      'ordem': serializer.toJson<int>(ordem),
    };
  }

  Categoria copyWith({
    String? id,
    String? nome,
    String? icone,
    bool? mostraData,
    bool? mostraHora,
    bool? mostraTelefone,
    bool? mostraEmail,
    bool? mostraValor,
    bool? mostraVencimento,
    bool? mostraMedico,
    bool? mostraNumeroDocumento,
    bool? mostraPrazo,
    int? ordem,
  }) => Categoria(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    icone: icone ?? this.icone,
    mostraData: mostraData ?? this.mostraData,
    mostraHora: mostraHora ?? this.mostraHora,
    mostraTelefone: mostraTelefone ?? this.mostraTelefone,
    mostraEmail: mostraEmail ?? this.mostraEmail,
    mostraValor: mostraValor ?? this.mostraValor,
    mostraVencimento: mostraVencimento ?? this.mostraVencimento,
    mostraMedico: mostraMedico ?? this.mostraMedico,
    mostraNumeroDocumento: mostraNumeroDocumento ?? this.mostraNumeroDocumento,
    mostraPrazo: mostraPrazo ?? this.mostraPrazo,
    ordem: ordem ?? this.ordem,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      icone: data.icone.present ? data.icone.value : this.icone,
      mostraData: data.mostraData.present
          ? data.mostraData.value
          : this.mostraData,
      mostraHora: data.mostraHora.present
          ? data.mostraHora.value
          : this.mostraHora,
      mostraTelefone: data.mostraTelefone.present
          ? data.mostraTelefone.value
          : this.mostraTelefone,
      mostraEmail: data.mostraEmail.present
          ? data.mostraEmail.value
          : this.mostraEmail,
      mostraValor: data.mostraValor.present
          ? data.mostraValor.value
          : this.mostraValor,
      mostraVencimento: data.mostraVencimento.present
          ? data.mostraVencimento.value
          : this.mostraVencimento,
      mostraMedico: data.mostraMedico.present
          ? data.mostraMedico.value
          : this.mostraMedico,
      mostraNumeroDocumento: data.mostraNumeroDocumento.present
          ? data.mostraNumeroDocumento.value
          : this.mostraNumeroDocumento,
      mostraPrazo: data.mostraPrazo.present
          ? data.mostraPrazo.value
          : this.mostraPrazo,
      ordem: data.ordem.present ? data.ordem.value : this.ordem,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('mostraData: $mostraData, ')
          ..write('mostraHora: $mostraHora, ')
          ..write('mostraTelefone: $mostraTelefone, ')
          ..write('mostraEmail: $mostraEmail, ')
          ..write('mostraValor: $mostraValor, ')
          ..write('mostraVencimento: $mostraVencimento, ')
          ..write('mostraMedico: $mostraMedico, ')
          ..write('mostraNumeroDocumento: $mostraNumeroDocumento, ')
          ..write('mostraPrazo: $mostraPrazo, ')
          ..write('ordem: $ordem')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    icone,
    mostraData,
    mostraHora,
    mostraTelefone,
    mostraEmail,
    mostraValor,
    mostraVencimento,
    mostraMedico,
    mostraNumeroDocumento,
    mostraPrazo,
    ordem,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.icone == this.icone &&
          other.mostraData == this.mostraData &&
          other.mostraHora == this.mostraHora &&
          other.mostraTelefone == this.mostraTelefone &&
          other.mostraEmail == this.mostraEmail &&
          other.mostraValor == this.mostraValor &&
          other.mostraVencimento == this.mostraVencimento &&
          other.mostraMedico == this.mostraMedico &&
          other.mostraNumeroDocumento == this.mostraNumeroDocumento &&
          other.mostraPrazo == this.mostraPrazo &&
          other.ordem == this.ordem);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> icone;
  final Value<bool> mostraData;
  final Value<bool> mostraHora;
  final Value<bool> mostraTelefone;
  final Value<bool> mostraEmail;
  final Value<bool> mostraValor;
  final Value<bool> mostraVencimento;
  final Value<bool> mostraMedico;
  final Value<bool> mostraNumeroDocumento;
  final Value<bool> mostraPrazo;
  final Value<int> ordem;
  final Value<int> rowid;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.icone = const Value.absent(),
    this.mostraData = const Value.absent(),
    this.mostraHora = const Value.absent(),
    this.mostraTelefone = const Value.absent(),
    this.mostraEmail = const Value.absent(),
    this.mostraValor = const Value.absent(),
    this.mostraVencimento = const Value.absent(),
    this.mostraMedico = const Value.absent(),
    this.mostraNumeroDocumento = const Value.absent(),
    this.mostraPrazo = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriasCompanion.insert({
    required String id,
    required String nome,
    required String icone,
    this.mostraData = const Value.absent(),
    this.mostraHora = const Value.absent(),
    this.mostraTelefone = const Value.absent(),
    this.mostraEmail = const Value.absent(),
    this.mostraValor = const Value.absent(),
    this.mostraVencimento = const Value.absent(),
    this.mostraMedico = const Value.absent(),
    this.mostraNumeroDocumento = const Value.absent(),
    this.mostraPrazo = const Value.absent(),
    this.ordem = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome),
       icone = Value(icone);
  static Insertable<Categoria> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? icone,
    Expression<bool>? mostraData,
    Expression<bool>? mostraHora,
    Expression<bool>? mostraTelefone,
    Expression<bool>? mostraEmail,
    Expression<bool>? mostraValor,
    Expression<bool>? mostraVencimento,
    Expression<bool>? mostraMedico,
    Expression<bool>? mostraNumeroDocumento,
    Expression<bool>? mostraPrazo,
    Expression<int>? ordem,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (icone != null) 'icone': icone,
      if (mostraData != null) 'mostra_data': mostraData,
      if (mostraHora != null) 'mostra_hora': mostraHora,
      if (mostraTelefone != null) 'mostra_telefone': mostraTelefone,
      if (mostraEmail != null) 'mostra_email': mostraEmail,
      if (mostraValor != null) 'mostra_valor': mostraValor,
      if (mostraVencimento != null) 'mostra_vencimento': mostraVencimento,
      if (mostraMedico != null) 'mostra_medico': mostraMedico,
      if (mostraNumeroDocumento != null)
        'mostra_numero_documento': mostraNumeroDocumento,
      if (mostraPrazo != null) 'mostra_prazo': mostraPrazo,
      if (ordem != null) 'ordem': ordem,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriasCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<String>? icone,
    Value<bool>? mostraData,
    Value<bool>? mostraHora,
    Value<bool>? mostraTelefone,
    Value<bool>? mostraEmail,
    Value<bool>? mostraValor,
    Value<bool>? mostraVencimento,
    Value<bool>? mostraMedico,
    Value<bool>? mostraNumeroDocumento,
    Value<bool>? mostraPrazo,
    Value<int>? ordem,
    Value<int>? rowid,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      mostraData: mostraData ?? this.mostraData,
      mostraHora: mostraHora ?? this.mostraHora,
      mostraTelefone: mostraTelefone ?? this.mostraTelefone,
      mostraEmail: mostraEmail ?? this.mostraEmail,
      mostraValor: mostraValor ?? this.mostraValor,
      mostraVencimento: mostraVencimento ?? this.mostraVencimento,
      mostraMedico: mostraMedico ?? this.mostraMedico,
      mostraNumeroDocumento:
          mostraNumeroDocumento ?? this.mostraNumeroDocumento,
      mostraPrazo: mostraPrazo ?? this.mostraPrazo,
      ordem: ordem ?? this.ordem,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (icone.present) {
      map['icone'] = Variable<String>(icone.value);
    }
    if (mostraData.present) {
      map['mostra_data'] = Variable<bool>(mostraData.value);
    }
    if (mostraHora.present) {
      map['mostra_hora'] = Variable<bool>(mostraHora.value);
    }
    if (mostraTelefone.present) {
      map['mostra_telefone'] = Variable<bool>(mostraTelefone.value);
    }
    if (mostraEmail.present) {
      map['mostra_email'] = Variable<bool>(mostraEmail.value);
    }
    if (mostraValor.present) {
      map['mostra_valor'] = Variable<bool>(mostraValor.value);
    }
    if (mostraVencimento.present) {
      map['mostra_vencimento'] = Variable<bool>(mostraVencimento.value);
    }
    if (mostraMedico.present) {
      map['mostra_medico'] = Variable<bool>(mostraMedico.value);
    }
    if (mostraNumeroDocumento.present) {
      map['mostra_numero_documento'] = Variable<bool>(
        mostraNumeroDocumento.value,
      );
    }
    if (mostraPrazo.present) {
      map['mostra_prazo'] = Variable<bool>(mostraPrazo.value);
    }
    if (ordem.present) {
      map['ordem'] = Variable<int>(ordem.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('icone: $icone, ')
          ..write('mostraData: $mostraData, ')
          ..write('mostraHora: $mostraHora, ')
          ..write('mostraTelefone: $mostraTelefone, ')
          ..write('mostraEmail: $mostraEmail, ')
          ..write('mostraValor: $mostraValor, ')
          ..write('mostraVencimento: $mostraVencimento, ')
          ..write('mostraMedico: $mostraMedico, ')
          ..write('mostraNumeroDocumento: $mostraNumeroDocumento, ')
          ..write('mostraPrazo: $mostraPrazo, ')
          ..write('ordem: $ordem, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RegistrosTable extends Registros
    with TableInfo<$RegistrosTable, Registro> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegistrosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<String> categoriaId = GeneratedColumn<String>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _conteudoMeta = const VerificationMeta(
    'conteudo',
  );
  @override
  late final GeneratedColumn<String> conteudo = GeneratedColumn<String>(
    'conteudo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _extrasMeta = const VerificationMeta('extras');
  @override
  late final GeneratedColumn<String> extras = GeneratedColumn<String>(
    'extras',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lembreteMeta = const VerificationMeta(
    'lembrete',
  );
  @override
  late final GeneratedColumn<DateTime> lembrete = GeneratedColumn<DateTime>(
    'lembrete',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletadoMeta = const VerificationMeta(
    'deletado',
  );
  @override
  late final GeneratedColumn<bool> deletado = GeneratedColumn<bool>(
    'deletado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deletado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoriaId,
    titulo,
    conteudo,
    extras,
    data,
    lembrete,
    deletado,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registros';
  @override
  VerificationContext validateIntegrity(
    Insertable<Registro> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    }
    if (data.containsKey('conteudo')) {
      context.handle(
        _conteudoMeta,
        conteudo.isAcceptableOrUnknown(data['conteudo']!, _conteudoMeta),
      );
    }
    if (data.containsKey('extras')) {
      context.handle(
        _extrasMeta,
        extras.isAcceptableOrUnknown(data['extras']!, _extrasMeta),
      );
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('lembrete')) {
      context.handle(
        _lembreteMeta,
        lembrete.isAcceptableOrUnknown(data['lembrete']!, _lembreteMeta),
      );
    }
    if (data.containsKey('deletado')) {
      context.handle(
        _deletadoMeta,
        deletado.isAcceptableOrUnknown(data['deletado']!, _deletadoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Registro map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Registro(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria_id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      conteudo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conteudo'],
      )!,
      extras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extras'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data'],
      ),
      lembrete: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lembrete'],
      ),
      deletado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deletado'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RegistrosTable createAlias(String alias) {
    return $RegistrosTable(attachedDatabase, alias);
  }
}

class Registro extends DataClass implements Insertable<Registro> {
  final String id;
  final String categoriaId;
  final String titulo;
  final String conteudo;
  final String extras;
  final DateTime? data;
  final DateTime? lembrete;
  final bool deletado;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Registro({
    required this.id,
    required this.categoriaId,
    required this.titulo,
    required this.conteudo,
    required this.extras,
    this.data,
    this.lembrete,
    required this.deletado,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['categoria_id'] = Variable<String>(categoriaId);
    map['titulo'] = Variable<String>(titulo);
    map['conteudo'] = Variable<String>(conteudo);
    map['extras'] = Variable<String>(extras);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<DateTime>(data);
    }
    if (!nullToAbsent || lembrete != null) {
      map['lembrete'] = Variable<DateTime>(lembrete);
    }
    map['deletado'] = Variable<bool>(deletado);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RegistrosCompanion toCompanion(bool nullToAbsent) {
    return RegistrosCompanion(
      id: Value(id),
      categoriaId: Value(categoriaId),
      titulo: Value(titulo),
      conteudo: Value(conteudo),
      extras: Value(extras),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      lembrete: lembrete == null && nullToAbsent
          ? const Value.absent()
          : Value(lembrete),
      deletado: Value(deletado),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Registro.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Registro(
      id: serializer.fromJson<String>(json['id']),
      categoriaId: serializer.fromJson<String>(json['categoriaId']),
      titulo: serializer.fromJson<String>(json['titulo']),
      conteudo: serializer.fromJson<String>(json['conteudo']),
      extras: serializer.fromJson<String>(json['extras']),
      data: serializer.fromJson<DateTime?>(json['data']),
      lembrete: serializer.fromJson<DateTime?>(json['lembrete']),
      deletado: serializer.fromJson<bool>(json['deletado']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoriaId': serializer.toJson<String>(categoriaId),
      'titulo': serializer.toJson<String>(titulo),
      'conteudo': serializer.toJson<String>(conteudo),
      'extras': serializer.toJson<String>(extras),
      'data': serializer.toJson<DateTime?>(data),
      'lembrete': serializer.toJson<DateTime?>(lembrete),
      'deletado': serializer.toJson<bool>(deletado),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Registro copyWith({
    String? id,
    String? categoriaId,
    String? titulo,
    String? conteudo,
    String? extras,
    Value<DateTime?> data = const Value.absent(),
    Value<DateTime?> lembrete = const Value.absent(),
    bool? deletado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Registro(
    id: id ?? this.id,
    categoriaId: categoriaId ?? this.categoriaId,
    titulo: titulo ?? this.titulo,
    conteudo: conteudo ?? this.conteudo,
    extras: extras ?? this.extras,
    data: data.present ? data.value : this.data,
    lembrete: lembrete.present ? lembrete.value : this.lembrete,
    deletado: deletado ?? this.deletado,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Registro copyWithCompanion(RegistrosCompanion data) {
    return Registro(
      id: data.id.present ? data.id.value : this.id,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      conteudo: data.conteudo.present ? data.conteudo.value : this.conteudo,
      extras: data.extras.present ? data.extras.value : this.extras,
      data: data.data.present ? data.data.value : this.data,
      lembrete: data.lembrete.present ? data.lembrete.value : this.lembrete,
      deletado: data.deletado.present ? data.deletado.value : this.deletado,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Registro(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('titulo: $titulo, ')
          ..write('conteudo: $conteudo, ')
          ..write('extras: $extras, ')
          ..write('data: $data, ')
          ..write('lembrete: $lembrete, ')
          ..write('deletado: $deletado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoriaId,
    titulo,
    conteudo,
    extras,
    data,
    lembrete,
    deletado,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Registro &&
          other.id == this.id &&
          other.categoriaId == this.categoriaId &&
          other.titulo == this.titulo &&
          other.conteudo == this.conteudo &&
          other.extras == this.extras &&
          other.data == this.data &&
          other.lembrete == this.lembrete &&
          other.deletado == this.deletado &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RegistrosCompanion extends UpdateCompanion<Registro> {
  final Value<String> id;
  final Value<String> categoriaId;
  final Value<String> titulo;
  final Value<String> conteudo;
  final Value<String> extras;
  final Value<DateTime?> data;
  final Value<DateTime?> lembrete;
  final Value<bool> deletado;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RegistrosCompanion({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.titulo = const Value.absent(),
    this.conteudo = const Value.absent(),
    this.extras = const Value.absent(),
    this.data = const Value.absent(),
    this.lembrete = const Value.absent(),
    this.deletado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RegistrosCompanion.insert({
    required String id,
    required String categoriaId,
    this.titulo = const Value.absent(),
    this.conteudo = const Value.absent(),
    this.extras = const Value.absent(),
    this.data = const Value.absent(),
    this.lembrete = const Value.absent(),
    this.deletado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoriaId = Value(categoriaId);
  static Insertable<Registro> custom({
    Expression<String>? id,
    Expression<String>? categoriaId,
    Expression<String>? titulo,
    Expression<String>? conteudo,
    Expression<String>? extras,
    Expression<DateTime>? data,
    Expression<DateTime>? lembrete,
    Expression<bool>? deletado,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (titulo != null) 'titulo': titulo,
      if (conteudo != null) 'conteudo': conteudo,
      if (extras != null) 'extras': extras,
      if (data != null) 'data': data,
      if (lembrete != null) 'lembrete': lembrete,
      if (deletado != null) 'deletado': deletado,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RegistrosCompanion copyWith({
    Value<String>? id,
    Value<String>? categoriaId,
    Value<String>? titulo,
    Value<String>? conteudo,
    Value<String>? extras,
    Value<DateTime?>? data,
    Value<DateTime?>? lembrete,
    Value<bool>? deletado,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RegistrosCompanion(
      id: id ?? this.id,
      categoriaId: categoriaId ?? this.categoriaId,
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
      extras: extras ?? this.extras,
      data: data ?? this.data,
      lembrete: lembrete ?? this.lembrete,
      deletado: deletado ?? this.deletado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<String>(categoriaId.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (conteudo.present) {
      map['conteudo'] = Variable<String>(conteudo.value);
    }
    if (extras.present) {
      map['extras'] = Variable<String>(extras.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (lembrete.present) {
      map['lembrete'] = Variable<DateTime>(lembrete.value);
    }
    if (deletado.present) {
      map['deletado'] = Variable<bool>(deletado.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegistrosCompanion(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('titulo: $titulo, ')
          ..write('conteudo: $conteudo, ')
          ..write('extras: $extras, ')
          ..write('data: $data, ')
          ..write('lembrete: $lembrete, ')
          ..write('deletado: $deletado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnexosTable extends Anexos with TableInfo<$AnexosTable, Anexo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnexosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registroIdMeta = const VerificationMeta(
    'registroId',
  );
  @override
  late final GeneratedColumn<String> registroId = GeneratedColumn<String>(
    'registro_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES registros (id)',
    ),
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('imagem'),
  );
  static const VerificationMeta _nomeArquivoMeta = const VerificationMeta(
    'nomeArquivo',
  );
  @override
  late final GeneratedColumn<String> nomeArquivo = GeneratedColumn<String>(
    'nome_arquivo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caminhoLocalMeta = const VerificationMeta(
    'caminhoLocal',
  );
  @override
  late final GeneratedColumn<String> caminhoLocal = GeneratedColumn<String>(
    'caminho_local',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tamanhoBytesMeta = const VerificationMeta(
    'tamanhoBytes',
  );
  @override
  late final GeneratedColumn<int> tamanhoBytes = GeneratedColumn<int>(
    'tamanho_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoMeta = const VerificationMeta(
    'sincronizado',
  );
  @override
  late final GeneratedColumn<bool> sincronizado = GeneratedColumn<bool>(
    'sincronizado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sincronizado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deletadoMeta = const VerificationMeta(
    'deletado',
  );
  @override
  late final GeneratedColumn<bool> deletado = GeneratedColumn<bool>(
    'deletado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deletado" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    registroId,
    tipo,
    nomeArquivo,
    caminhoLocal,
    mimeType,
    tamanhoBytes,
    sincronizado,
    deletado,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anexos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Anexo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('registro_id')) {
      context.handle(
        _registroIdMeta,
        registroId.isAcceptableOrUnknown(data['registro_id']!, _registroIdMeta),
      );
    } else if (isInserting) {
      context.missing(_registroIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    }
    if (data.containsKey('nome_arquivo')) {
      context.handle(
        _nomeArquivoMeta,
        nomeArquivo.isAcceptableOrUnknown(
          data['nome_arquivo']!,
          _nomeArquivoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nomeArquivoMeta);
    }
    if (data.containsKey('caminho_local')) {
      context.handle(
        _caminhoLocalMeta,
        caminhoLocal.isAcceptableOrUnknown(
          data['caminho_local']!,
          _caminhoLocalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caminhoLocalMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('tamanho_bytes')) {
      context.handle(
        _tamanhoBytesMeta,
        tamanhoBytes.isAcceptableOrUnknown(
          data['tamanho_bytes']!,
          _tamanhoBytesMeta,
        ),
      );
    }
    if (data.containsKey('sincronizado')) {
      context.handle(
        _sincronizadoMeta,
        sincronizado.isAcceptableOrUnknown(
          data['sincronizado']!,
          _sincronizadoMeta,
        ),
      );
    }
    if (data.containsKey('deletado')) {
      context.handle(
        _deletadoMeta,
        deletado.isAcceptableOrUnknown(data['deletado']!, _deletadoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Anexo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Anexo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      registroId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registro_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      nomeArquivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_arquivo'],
      )!,
      caminhoLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caminho_local'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      tamanhoBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tamanho_bytes'],
      ),
      sincronizado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sincronizado'],
      )!,
      deletado: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deletado'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AnexosTable createAlias(String alias) {
    return $AnexosTable(attachedDatabase, alias);
  }
}

class Anexo extends DataClass implements Insertable<Anexo> {
  final String id;
  final String registroId;
  final String tipo;
  final String nomeArquivo;
  final String caminhoLocal;
  final String? mimeType;
  final int? tamanhoBytes;
  final bool sincronizado;
  final bool deletado;
  final String createdAt;
  final String updatedAt;
  const Anexo({
    required this.id,
    required this.registroId,
    required this.tipo,
    required this.nomeArquivo,
    required this.caminhoLocal,
    this.mimeType,
    this.tamanhoBytes,
    required this.sincronizado,
    required this.deletado,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['registro_id'] = Variable<String>(registroId);
    map['tipo'] = Variable<String>(tipo);
    map['nome_arquivo'] = Variable<String>(nomeArquivo);
    map['caminho_local'] = Variable<String>(caminhoLocal);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || tamanhoBytes != null) {
      map['tamanho_bytes'] = Variable<int>(tamanhoBytes);
    }
    map['sincronizado'] = Variable<bool>(sincronizado);
    map['deletado'] = Variable<bool>(deletado);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  AnexosCompanion toCompanion(bool nullToAbsent) {
    return AnexosCompanion(
      id: Value(id),
      registroId: Value(registroId),
      tipo: Value(tipo),
      nomeArquivo: Value(nomeArquivo),
      caminhoLocal: Value(caminhoLocal),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      tamanhoBytes: tamanhoBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(tamanhoBytes),
      sincronizado: Value(sincronizado),
      deletado: Value(deletado),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Anexo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Anexo(
      id: serializer.fromJson<String>(json['id']),
      registroId: serializer.fromJson<String>(json['registroId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      nomeArquivo: serializer.fromJson<String>(json['nomeArquivo']),
      caminhoLocal: serializer.fromJson<String>(json['caminhoLocal']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      tamanhoBytes: serializer.fromJson<int?>(json['tamanhoBytes']),
      sincronizado: serializer.fromJson<bool>(json['sincronizado']),
      deletado: serializer.fromJson<bool>(json['deletado']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'registroId': serializer.toJson<String>(registroId),
      'tipo': serializer.toJson<String>(tipo),
      'nomeArquivo': serializer.toJson<String>(nomeArquivo),
      'caminhoLocal': serializer.toJson<String>(caminhoLocal),
      'mimeType': serializer.toJson<String?>(mimeType),
      'tamanhoBytes': serializer.toJson<int?>(tamanhoBytes),
      'sincronizado': serializer.toJson<bool>(sincronizado),
      'deletado': serializer.toJson<bool>(deletado),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Anexo copyWith({
    String? id,
    String? registroId,
    String? tipo,
    String? nomeArquivo,
    String? caminhoLocal,
    Value<String?> mimeType = const Value.absent(),
    Value<int?> tamanhoBytes = const Value.absent(),
    bool? sincronizado,
    bool? deletado,
    String? createdAt,
    String? updatedAt,
  }) => Anexo(
    id: id ?? this.id,
    registroId: registroId ?? this.registroId,
    tipo: tipo ?? this.tipo,
    nomeArquivo: nomeArquivo ?? this.nomeArquivo,
    caminhoLocal: caminhoLocal ?? this.caminhoLocal,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    tamanhoBytes: tamanhoBytes.present ? tamanhoBytes.value : this.tamanhoBytes,
    sincronizado: sincronizado ?? this.sincronizado,
    deletado: deletado ?? this.deletado,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Anexo copyWithCompanion(AnexosCompanion data) {
    return Anexo(
      id: data.id.present ? data.id.value : this.id,
      registroId: data.registroId.present
          ? data.registroId.value
          : this.registroId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      nomeArquivo: data.nomeArquivo.present
          ? data.nomeArquivo.value
          : this.nomeArquivo,
      caminhoLocal: data.caminhoLocal.present
          ? data.caminhoLocal.value
          : this.caminhoLocal,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      tamanhoBytes: data.tamanhoBytes.present
          ? data.tamanhoBytes.value
          : this.tamanhoBytes,
      sincronizado: data.sincronizado.present
          ? data.sincronizado.value
          : this.sincronizado,
      deletado: data.deletado.present ? data.deletado.value : this.deletado,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Anexo(')
          ..write('id: $id, ')
          ..write('registroId: $registroId, ')
          ..write('tipo: $tipo, ')
          ..write('nomeArquivo: $nomeArquivo, ')
          ..write('caminhoLocal: $caminhoLocal, ')
          ..write('mimeType: $mimeType, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('deletado: $deletado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    registroId,
    tipo,
    nomeArquivo,
    caminhoLocal,
    mimeType,
    tamanhoBytes,
    sincronizado,
    deletado,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Anexo &&
          other.id == this.id &&
          other.registroId == this.registroId &&
          other.tipo == this.tipo &&
          other.nomeArquivo == this.nomeArquivo &&
          other.caminhoLocal == this.caminhoLocal &&
          other.mimeType == this.mimeType &&
          other.tamanhoBytes == this.tamanhoBytes &&
          other.sincronizado == this.sincronizado &&
          other.deletado == this.deletado &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AnexosCompanion extends UpdateCompanion<Anexo> {
  final Value<String> id;
  final Value<String> registroId;
  final Value<String> tipo;
  final Value<String> nomeArquivo;
  final Value<String> caminhoLocal;
  final Value<String?> mimeType;
  final Value<int?> tamanhoBytes;
  final Value<bool> sincronizado;
  final Value<bool> deletado;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const AnexosCompanion({
    this.id = const Value.absent(),
    this.registroId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.nomeArquivo = const Value.absent(),
    this.caminhoLocal = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.tamanhoBytes = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.deletado = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnexosCompanion.insert({
    required String id,
    required String registroId,
    this.tipo = const Value.absent(),
    required String nomeArquivo,
    required String caminhoLocal,
    this.mimeType = const Value.absent(),
    this.tamanhoBytes = const Value.absent(),
    this.sincronizado = const Value.absent(),
    this.deletado = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       registroId = Value(registroId),
       nomeArquivo = Value(nomeArquivo),
       caminhoLocal = Value(caminhoLocal),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Anexo> custom({
    Expression<String>? id,
    Expression<String>? registroId,
    Expression<String>? tipo,
    Expression<String>? nomeArquivo,
    Expression<String>? caminhoLocal,
    Expression<String>? mimeType,
    Expression<int>? tamanhoBytes,
    Expression<bool>? sincronizado,
    Expression<bool>? deletado,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (registroId != null) 'registro_id': registroId,
      if (tipo != null) 'tipo': tipo,
      if (nomeArquivo != null) 'nome_arquivo': nomeArquivo,
      if (caminhoLocal != null) 'caminho_local': caminhoLocal,
      if (mimeType != null) 'mime_type': mimeType,
      if (tamanhoBytes != null) 'tamanho_bytes': tamanhoBytes,
      if (sincronizado != null) 'sincronizado': sincronizado,
      if (deletado != null) 'deletado': deletado,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnexosCompanion copyWith({
    Value<String>? id,
    Value<String>? registroId,
    Value<String>? tipo,
    Value<String>? nomeArquivo,
    Value<String>? caminhoLocal,
    Value<String?>? mimeType,
    Value<int?>? tamanhoBytes,
    Value<bool>? sincronizado,
    Value<bool>? deletado,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return AnexosCompanion(
      id: id ?? this.id,
      registroId: registroId ?? this.registroId,
      tipo: tipo ?? this.tipo,
      nomeArquivo: nomeArquivo ?? this.nomeArquivo,
      caminhoLocal: caminhoLocal ?? this.caminhoLocal,
      mimeType: mimeType ?? this.mimeType,
      tamanhoBytes: tamanhoBytes ?? this.tamanhoBytes,
      sincronizado: sincronizado ?? this.sincronizado,
      deletado: deletado ?? this.deletado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (registroId.present) {
      map['registro_id'] = Variable<String>(registroId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (nomeArquivo.present) {
      map['nome_arquivo'] = Variable<String>(nomeArquivo.value);
    }
    if (caminhoLocal.present) {
      map['caminho_local'] = Variable<String>(caminhoLocal.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (tamanhoBytes.present) {
      map['tamanho_bytes'] = Variable<int>(tamanhoBytes.value);
    }
    if (sincronizado.present) {
      map['sincronizado'] = Variable<bool>(sincronizado.value);
    }
    if (deletado.present) {
      map['deletado'] = Variable<bool>(deletado.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnexosCompanion(')
          ..write('id: $id, ')
          ..write('registroId: $registroId, ')
          ..write('tipo: $tipo, ')
          ..write('nomeArquivo: $nomeArquivo, ')
          ..write('caminhoLocal: $caminhoLocal, ')
          ..write('mimeType: $mimeType, ')
          ..write('tamanhoBytes: $tamanhoBytes, ')
          ..write('sincronizado: $sincronizado, ')
          ..write('deletado: $deletado, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $RegistrosTable registros = $RegistrosTable(this);
  late final $AnexosTable anexos = $AnexosTable(this);
  late final CategoriasDao categoriasDao = CategoriasDao(this as AppDatabase);
  late final RegistrosDao registrosDao = RegistrosDao(this as AppDatabase);
  late final AnexosDao anexosDao = AnexosDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categorias,
    registros,
    anexos,
  ];
}

typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      required String id,
      required String nome,
      required String icone,
      Value<bool> mostraData,
      Value<bool> mostraHora,
      Value<bool> mostraTelefone,
      Value<bool> mostraEmail,
      Value<bool> mostraValor,
      Value<bool> mostraVencimento,
      Value<bool> mostraMedico,
      Value<bool> mostraNumeroDocumento,
      Value<bool> mostraPrazo,
      Value<int> ordem,
      Value<int> rowid,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<String> id,
      Value<String> nome,
      Value<String> icone,
      Value<bool> mostraData,
      Value<bool> mostraHora,
      Value<bool> mostraTelefone,
      Value<bool> mostraEmail,
      Value<bool> mostraValor,
      Value<bool> mostraVencimento,
      Value<bool> mostraMedico,
      Value<bool> mostraNumeroDocumento,
      Value<bool> mostraPrazo,
      Value<int> ordem,
      Value<int> rowid,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RegistrosTable, List<Registro>>
  _registrosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.registros,
    aliasName: $_aliasNameGenerator(db.categorias.id, db.registros.categoriaId),
  );

  $$RegistrosTableProcessedTableManager get registrosRefs {
    final manager = $$RegistrosTableTableManager(
      $_db,
      $_db.registros,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_registrosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraData => $composableBuilder(
    column: $table.mostraData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraHora => $composableBuilder(
    column: $table.mostraHora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraTelefone => $composableBuilder(
    column: $table.mostraTelefone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraEmail => $composableBuilder(
    column: $table.mostraEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraValor => $composableBuilder(
    column: $table.mostraValor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraVencimento => $composableBuilder(
    column: $table.mostraVencimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraMedico => $composableBuilder(
    column: $table.mostraMedico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraNumeroDocumento => $composableBuilder(
    column: $table.mostraNumeroDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get mostraPrazo => $composableBuilder(
    column: $table.mostraPrazo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> registrosRefs(
    Expression<bool> Function($$RegistrosTableFilterComposer f) f,
  ) {
    final $$RegistrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registros,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosTableFilterComposer(
            $db: $db,
            $table: $db.registros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icone => $composableBuilder(
    column: $table.icone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraData => $composableBuilder(
    column: $table.mostraData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraHora => $composableBuilder(
    column: $table.mostraHora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraTelefone => $composableBuilder(
    column: $table.mostraTelefone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraEmail => $composableBuilder(
    column: $table.mostraEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraValor => $composableBuilder(
    column: $table.mostraValor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraVencimento => $composableBuilder(
    column: $table.mostraVencimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraMedico => $composableBuilder(
    column: $table.mostraMedico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraNumeroDocumento => $composableBuilder(
    column: $table.mostraNumeroDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get mostraPrazo => $composableBuilder(
    column: $table.mostraPrazo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ordem => $composableBuilder(
    column: $table.ordem,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get icone =>
      $composableBuilder(column: $table.icone, builder: (column) => column);

  GeneratedColumn<bool> get mostraData => $composableBuilder(
    column: $table.mostraData,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraHora => $composableBuilder(
    column: $table.mostraHora,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraTelefone => $composableBuilder(
    column: $table.mostraTelefone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraEmail => $composableBuilder(
    column: $table.mostraEmail,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraValor => $composableBuilder(
    column: $table.mostraValor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraVencimento => $composableBuilder(
    column: $table.mostraVencimento,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraMedico => $composableBuilder(
    column: $table.mostraMedico,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraNumeroDocumento => $composableBuilder(
    column: $table.mostraNumeroDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get mostraPrazo => $composableBuilder(
    column: $table.mostraPrazo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ordem =>
      $composableBuilder(column: $table.ordem, builder: (column) => column);

  Expression<T> registrosRefs<T extends Object>(
    Expression<T> Function($$RegistrosTableAnnotationComposer a) f,
  ) {
    final $$RegistrosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.registros,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosTableAnnotationComposer(
            $db: $db,
            $table: $db.registros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({bool registrosRefs})
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> icone = const Value.absent(),
                Value<bool> mostraData = const Value.absent(),
                Value<bool> mostraHora = const Value.absent(),
                Value<bool> mostraTelefone = const Value.absent(),
                Value<bool> mostraEmail = const Value.absent(),
                Value<bool> mostraValor = const Value.absent(),
                Value<bool> mostraVencimento = const Value.absent(),
                Value<bool> mostraMedico = const Value.absent(),
                Value<bool> mostraNumeroDocumento = const Value.absent(),
                Value<bool> mostraPrazo = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nome: nome,
                icone: icone,
                mostraData: mostraData,
                mostraHora: mostraHora,
                mostraTelefone: mostraTelefone,
                mostraEmail: mostraEmail,
                mostraValor: mostraValor,
                mostraVencimento: mostraVencimento,
                mostraMedico: mostraMedico,
                mostraNumeroDocumento: mostraNumeroDocumento,
                mostraPrazo: mostraPrazo,
                ordem: ordem,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nome,
                required String icone,
                Value<bool> mostraData = const Value.absent(),
                Value<bool> mostraHora = const Value.absent(),
                Value<bool> mostraTelefone = const Value.absent(),
                Value<bool> mostraEmail = const Value.absent(),
                Value<bool> mostraValor = const Value.absent(),
                Value<bool> mostraVencimento = const Value.absent(),
                Value<bool> mostraMedico = const Value.absent(),
                Value<bool> mostraNumeroDocumento = const Value.absent(),
                Value<bool> mostraPrazo = const Value.absent(),
                Value<int> ordem = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nome: nome,
                icone: icone,
                mostraData: mostraData,
                mostraHora: mostraHora,
                mostraTelefone: mostraTelefone,
                mostraEmail: mostraEmail,
                mostraValor: mostraValor,
                mostraVencimento: mostraVencimento,
                mostraMedico: mostraMedico,
                mostraNumeroDocumento: mostraNumeroDocumento,
                mostraPrazo: mostraPrazo,
                ordem: ordem,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({registrosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (registrosRefs) db.registros],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (registrosRefs)
                    await $_getPrefetchedData<
                      Categoria,
                      $CategoriasTable,
                      Registro
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriasTableReferences
                          ._registrosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriasTableReferences(
                            db,
                            table,
                            p0,
                          ).registrosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.categoriaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({bool registrosRefs})
    >;
typedef $$RegistrosTableCreateCompanionBuilder =
    RegistrosCompanion Function({
      required String id,
      required String categoriaId,
      Value<String> titulo,
      Value<String> conteudo,
      Value<String> extras,
      Value<DateTime?> data,
      Value<DateTime?> lembrete,
      Value<bool> deletado,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$RegistrosTableUpdateCompanionBuilder =
    RegistrosCompanion Function({
      Value<String> id,
      Value<String> categoriaId,
      Value<String> titulo,
      Value<String> conteudo,
      Value<String> extras,
      Value<DateTime?> data,
      Value<DateTime?> lembrete,
      Value<bool> deletado,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RegistrosTableReferences
    extends BaseReferences<_$AppDatabase, $RegistrosTable, Registro> {
  $$RegistrosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias(
        $_aliasNameGenerator(db.registros.categoriaId, db.categorias.id),
      );

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<String>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AnexosTable, List<Anexo>> _anexosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.anexos,
    aliasName: $_aliasNameGenerator(db.registros.id, db.anexos.registroId),
  );

  $$AnexosTableProcessedTableManager get anexosRefs {
    final manager = $$AnexosTableTableManager(
      $_db,
      $_db.anexos,
    ).filter((f) => f.registroId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_anexosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RegistrosTableFilterComposer
    extends Composer<_$AppDatabase, $RegistrosTable> {
  $$RegistrosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conteudo => $composableBuilder(
    column: $table.conteudo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extras => $composableBuilder(
    column: $table.extras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lembrete => $composableBuilder(
    column: $table.lembrete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletado => $composableBuilder(
    column: $table.deletado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> anexosRefs(
    Expression<bool> Function($$AnexosTableFilterComposer f) f,
  ) {
    final $$AnexosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anexos,
      getReferencedColumn: (t) => t.registroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnexosTableFilterComposer(
            $db: $db,
            $table: $db.anexos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegistrosTableOrderingComposer
    extends Composer<_$AppDatabase, $RegistrosTable> {
  $$RegistrosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conteudo => $composableBuilder(
    column: $table.conteudo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extras => $composableBuilder(
    column: $table.extras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lembrete => $composableBuilder(
    column: $table.lembrete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletado => $composableBuilder(
    column: $table.deletado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RegistrosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegistrosTable> {
  $$RegistrosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get conteudo =>
      $composableBuilder(column: $table.conteudo, builder: (column) => column);

  GeneratedColumn<String> get extras =>
      $composableBuilder(column: $table.extras, builder: (column) => column);

  GeneratedColumn<DateTime> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get lembrete =>
      $composableBuilder(column: $table.lembrete, builder: (column) => column);

  GeneratedColumn<bool> get deletado =>
      $composableBuilder(column: $table.deletado, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> anexosRefs<T extends Object>(
    Expression<T> Function($$AnexosTableAnnotationComposer a) f,
  ) {
    final $$AnexosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anexos,
      getReferencedColumn: (t) => t.registroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnexosTableAnnotationComposer(
            $db: $db,
            $table: $db.anexos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegistrosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegistrosTable,
          Registro,
          $$RegistrosTableFilterComposer,
          $$RegistrosTableOrderingComposer,
          $$RegistrosTableAnnotationComposer,
          $$RegistrosTableCreateCompanionBuilder,
          $$RegistrosTableUpdateCompanionBuilder,
          (Registro, $$RegistrosTableReferences),
          Registro,
          PrefetchHooks Function({bool categoriaId, bool anexosRefs})
        > {
  $$RegistrosTableTableManager(_$AppDatabase db, $RegistrosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegistrosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegistrosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegistrosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoriaId = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> conteudo = const Value.absent(),
                Value<String> extras = const Value.absent(),
                Value<DateTime?> data = const Value.absent(),
                Value<DateTime?> lembrete = const Value.absent(),
                Value<bool> deletado = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosCompanion(
                id: id,
                categoriaId: categoriaId,
                titulo: titulo,
                conteudo: conteudo,
                extras: extras,
                data: data,
                lembrete: lembrete,
                deletado: deletado,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoriaId,
                Value<String> titulo = const Value.absent(),
                Value<String> conteudo = const Value.absent(),
                Value<String> extras = const Value.absent(),
                Value<DateTime?> data = const Value.absent(),
                Value<DateTime?> lembrete = const Value.absent(),
                Value<bool> deletado = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RegistrosCompanion.insert(
                id: id,
                categoriaId: categoriaId,
                titulo: titulo,
                conteudo: conteudo,
                extras: extras,
                data: data,
                lembrete: lembrete,
                deletado: deletado,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RegistrosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false, anexosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (anexosRefs) db.anexos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoriaId,
                                referencedTable: $$RegistrosTableReferences
                                    ._categoriaIdTable(db),
                                referencedColumn: $$RegistrosTableReferences
                                    ._categoriaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (anexosRefs)
                    await $_getPrefetchedData<Registro, $RegistrosTable, Anexo>(
                      currentTable: table,
                      referencedTable: $$RegistrosTableReferences
                          ._anexosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RegistrosTableReferences(db, table, p0).anexosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.registroId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RegistrosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegistrosTable,
      Registro,
      $$RegistrosTableFilterComposer,
      $$RegistrosTableOrderingComposer,
      $$RegistrosTableAnnotationComposer,
      $$RegistrosTableCreateCompanionBuilder,
      $$RegistrosTableUpdateCompanionBuilder,
      (Registro, $$RegistrosTableReferences),
      Registro,
      PrefetchHooks Function({bool categoriaId, bool anexosRefs})
    >;
typedef $$AnexosTableCreateCompanionBuilder =
    AnexosCompanion Function({
      required String id,
      required String registroId,
      Value<String> tipo,
      required String nomeArquivo,
      required String caminhoLocal,
      Value<String?> mimeType,
      Value<int?> tamanhoBytes,
      Value<bool> sincronizado,
      Value<bool> deletado,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$AnexosTableUpdateCompanionBuilder =
    AnexosCompanion Function({
      Value<String> id,
      Value<String> registroId,
      Value<String> tipo,
      Value<String> nomeArquivo,
      Value<String> caminhoLocal,
      Value<String?> mimeType,
      Value<int?> tamanhoBytes,
      Value<bool> sincronizado,
      Value<bool> deletado,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

final class $$AnexosTableReferences
    extends BaseReferences<_$AppDatabase, $AnexosTable, Anexo> {
  $$AnexosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RegistrosTable _registroIdTable(_$AppDatabase db) => db.registros
      .createAlias($_aliasNameGenerator(db.anexos.registroId, db.registros.id));

  $$RegistrosTableProcessedTableManager get registroId {
    final $_column = $_itemColumn<String>('registro_id')!;

    final manager = $$RegistrosTableTableManager(
      $_db,
      $_db.registros,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_registroIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnexosTableFilterComposer
    extends Composer<_$AppDatabase, $AnexosTable> {
  $$AnexosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeArquivo => $composableBuilder(
    column: $table.nomeArquivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caminhoLocal => $composableBuilder(
    column: $table.caminhoLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deletado => $composableBuilder(
    column: $table.deletado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RegistrosTableFilterComposer get registroId {
    final $$RegistrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registroId,
      referencedTable: $db.registros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosTableFilterComposer(
            $db: $db,
            $table: $db.registros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnexosTableOrderingComposer
    extends Composer<_$AppDatabase, $AnexosTable> {
  $$AnexosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeArquivo => $composableBuilder(
    column: $table.nomeArquivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caminhoLocal => $composableBuilder(
    column: $table.caminhoLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deletado => $composableBuilder(
    column: $table.deletado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RegistrosTableOrderingComposer get registroId {
    final $$RegistrosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registroId,
      referencedTable: $db.registros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosTableOrderingComposer(
            $db: $db,
            $table: $db.registros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnexosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnexosTable> {
  $$AnexosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get nomeArquivo => $composableBuilder(
    column: $table.nomeArquivo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caminhoLocal => $composableBuilder(
    column: $table.caminhoLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get tamanhoBytes => $composableBuilder(
    column: $table.tamanhoBytes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sincronizado => $composableBuilder(
    column: $table.sincronizado,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get deletado =>
      $composableBuilder(column: $table.deletado, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RegistrosTableAnnotationComposer get registroId {
    final $$RegistrosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.registroId,
      referencedTable: $db.registros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegistrosTableAnnotationComposer(
            $db: $db,
            $table: $db.registros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnexosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnexosTable,
          Anexo,
          $$AnexosTableFilterComposer,
          $$AnexosTableOrderingComposer,
          $$AnexosTableAnnotationComposer,
          $$AnexosTableCreateCompanionBuilder,
          $$AnexosTableUpdateCompanionBuilder,
          (Anexo, $$AnexosTableReferences),
          Anexo,
          PrefetchHooks Function({bool registroId})
        > {
  $$AnexosTableTableManager(_$AppDatabase db, $AnexosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnexosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnexosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnexosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> registroId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String> nomeArquivo = const Value.absent(),
                Value<String> caminhoLocal = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int?> tamanhoBytes = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
                Value<bool> deletado = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnexosCompanion(
                id: id,
                registroId: registroId,
                tipo: tipo,
                nomeArquivo: nomeArquivo,
                caminhoLocal: caminhoLocal,
                mimeType: mimeType,
                tamanhoBytes: tamanhoBytes,
                sincronizado: sincronizado,
                deletado: deletado,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String registroId,
                Value<String> tipo = const Value.absent(),
                required String nomeArquivo,
                required String caminhoLocal,
                Value<String?> mimeType = const Value.absent(),
                Value<int?> tamanhoBytes = const Value.absent(),
                Value<bool> sincronizado = const Value.absent(),
                Value<bool> deletado = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AnexosCompanion.insert(
                id: id,
                registroId: registroId,
                tipo: tipo,
                nomeArquivo: nomeArquivo,
                caminhoLocal: caminhoLocal,
                mimeType: mimeType,
                tamanhoBytes: tamanhoBytes,
                sincronizado: sincronizado,
                deletado: deletado,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AnexosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({registroId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (registroId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.registroId,
                                referencedTable: $$AnexosTableReferences
                                    ._registroIdTable(db),
                                referencedColumn: $$AnexosTableReferences
                                    ._registroIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnexosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnexosTable,
      Anexo,
      $$AnexosTableFilterComposer,
      $$AnexosTableOrderingComposer,
      $$AnexosTableAnnotationComposer,
      $$AnexosTableCreateCompanionBuilder,
      $$AnexosTableUpdateCompanionBuilder,
      (Anexo, $$AnexosTableReferences),
      Anexo,
      PrefetchHooks Function({bool registroId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$RegistrosTableTableManager get registros =>
      $$RegistrosTableTableManager(_db, _db.registros);
  $$AnexosTableTableManager get anexos =>
      $$AnexosTableTableManager(_db, _db.anexos);
}
