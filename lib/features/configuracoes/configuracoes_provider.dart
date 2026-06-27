import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyUrl = 'api_url';
const _keyToken = 'api_token';
const _keyIntervalo = 'sync_intervalo_minutos';
const _keyLastSync = 'last_sync_at';

class Configuracoes {
  final String apiUrl;
  final String apiToken;
  final int intervaloMinutos;
  final DateTime? lastSyncAt;

  const Configuracoes({
    required this.apiUrl,
    required this.apiToken,
    required this.intervaloMinutos,
    this.lastSyncAt,
  });

  Configuracoes copyWith({
    String? apiUrl,
    String? apiToken,
    int? intervaloMinutos,
    DateTime? lastSyncAt,
  }) =>
      Configuracoes(
        apiUrl: apiUrl ?? this.apiUrl,
        apiToken: apiToken ?? this.apiToken,
        intervaloMinutos: intervaloMinutos ?? this.intervaloMinutos,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      );
}

class ConfiguracoesNotifier extends AsyncNotifier<Configuracoes> {
  @override
  Future<Configuracoes> build() async {
    final prefs = await SharedPreferences.getInstance();
    return Configuracoes(
      apiUrl: prefs.getString(_keyUrl) ??
          dotenv.env['API_BASE_URL'] ??
          'http://localhost:38080',
      apiToken: prefs.getString(_keyToken) ??
          dotenv.env['API_TOKEN'] ??
          '',
      intervaloMinutos: prefs.getInt(_keyIntervalo) ??
          int.tryParse(dotenv.env['SYNC_INTERVALO_MINUTOS'] ?? '') ??
          5,
      lastSyncAt: prefs.getString(_keyLastSync) != null
          ? DateTime.tryParse(prefs.getString(_keyLastSync)!)
          : null,
    );
  }

  Future<void> salvar({
    String? apiUrl,
    String? apiToken,
    int? intervaloMinutos,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final atual = state.valueOrNull;
    if (apiUrl != null) await prefs.setString(_keyUrl, apiUrl);
    if (apiToken != null) await prefs.setString(_keyToken, apiToken);
    if (intervaloMinutos != null) {
      await prefs.setInt(_keyIntervalo, intervaloMinutos);
    }
    state = AsyncData(
      (atual ?? const Configuracoes(apiUrl: '', apiToken: '', intervaloMinutos: 5))
          .copyWith(
        apiUrl: apiUrl,
        apiToken: apiToken,
        intervaloMinutos: intervaloMinutos,
      ),
    );
  }

  Future<void> atualizarLastSync(DateTime quando) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastSync, quando.toIso8601String());
    final atual = state.valueOrNull;
    if (atual != null) {
      state = AsyncData(atual.copyWith(lastSyncAt: quando));
    }
  }

  Future<void> limparLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLastSync);
    final atual = state.valueOrNull;
    if (atual != null) {
      state = AsyncData(Configuracoes(
        apiUrl: atual.apiUrl,
        apiToken: atual.apiToken,
        intervaloMinutos: atual.intervaloMinutos,
        lastSyncAt: null,
      ));
    }
  }
}

final configuracoesProvider =
    AsyncNotifierProvider<ConfiguracoesNotifier, Configuracoes>(
        ConfiguracoesNotifier.new);
