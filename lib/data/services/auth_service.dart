import 'dart:convert';
import 'package:api_produtos/data/config/api_config.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Chaves usadas no SharedPreferences (localStorage no Flutter Web).
const _kTokenKey = 'auth_token';
const _kExpiryKey = 'auth_token_expiry_ms';

class AuthService {
  final Dio _dio;

  String? _cachedToken;
  DateTime? _tokenExpiry;

  /// Guarda o Future em andamento para evitar requests duplicados
  /// quando várias chamadas concorrentes chegam antes do primeiro token ser salvo.
  Future<String>? _pendingFetch;

  AuthService(this._dio);

  // ─── API pública ────────────────────────────────────────────────────────────

  /// Retorna o token em cache (memória ou SharedPreferences) se ainda válido,
  /// senão busca um novo — garantindo que só UMA requisição seja feita mesmo
  /// com múltiplas chamadas concorrentes.
  Future<String> getToken() async {
    // 1. Cache em memória (mais rápido)
    if (_isTokenValid()) return _cachedToken!;

    // 2. Cache persistido (sobrevive a reloads no Flutter Web)
    final persisted = await _loadPersistedToken();
    if (persisted != null) return persisted;

    // 3. Precisa buscar um novo token.
    //    Se já existe um fetch em andamento, aguarda o mesmo Future
    //    em vez de disparar uma nova requisição.
    _pendingFetch ??= _fetchToken().whenComplete(() => _pendingFetch = null);
    return _pendingFetch!;
  }

  /// Invalida o cache para forçar novo login no próximo uso.
  Future<void> invalidateToken() async {
    _cachedToken = null;
    _tokenExpiry = null;
    _pendingFetch = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kExpiryKey);
  }

  // ─── Internos ───────────────────────────────────────────────────────────────

  bool _isTokenValid() =>
      _cachedToken != null &&
      _tokenExpiry != null &&
      DateTime.now().isBefore(_tokenExpiry!);

  /// Lê token e expiração do SharedPreferences.
  /// Retorna null se não existir ou já tiver expirado.
  Future<String?> _loadPersistedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_kTokenKey);
      final expiryMs = prefs.getInt(_kExpiryKey);
      if (token == null || expiryMs == null) return null;

      final expiry = DateTime.fromMillisecondsSinceEpoch(expiryMs);
      if (DateTime.now().isAfter(expiry)) return null;

      // Restaura cache em memória para as próximas chamadas (sem I/O)
      _cachedToken = token;
      _tokenExpiry = expiry;
      return token;
    } catch (_) {
      // SharedPreferences indisponível (ex.: testes): ignora
      return null;
    }
  }

  Future<String> _fetchToken() async {
    final credentials = base64Encode(
      utf8.encode('${ApiConfig.basicAuthUser}:${ApiConfig.basicAuthPassword}'),
    );

    final response = await _dio.post(
      '${ApiConfig.baseUrl}/auth/token',
      options: Options(
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/json',
        },
      ),
      data: {'slug': ApiConfig.slug},
    );

    final token = response.data['token'] as String;
    final expiresIn = (response.data['expires_in'] as num).toInt();

    // Subtrai 60 s de margem para evitar uso de token prestes a expirar
    final expiry = DateTime.now().add(Duration(seconds: expiresIn - 60));

    // Salva em memória
    _cachedToken = token;
    _tokenExpiry = expiry;

    // Persiste no SharedPreferences / localStorage (Flutter Web)
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTokenKey, token);
      await prefs.setInt(_kExpiryKey, expiry.millisecondsSinceEpoch);
    } catch (_) {
      // Persistência opcional: falha silenciosamente
    }

    return token;
  }
}
