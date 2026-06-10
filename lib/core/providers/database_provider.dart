import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

/// Instância única do banco — descartada quando o ProviderScope é removido.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
