import 'dart:convert';
import 'package:api_produtos/data/config/api_config.dart';
import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  String? _cachedToken;
  DateTime? _tokenExpiry;

  AuthService(this._dio);

  /// Retorna o token em cache se ainda válido, senão busca um novo.
  Future<String> getToken() async {
    if (_cachedToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _cachedToken!;
    }
    return _fetchToken();
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

    _cachedToken = token;
    // Subtrai 60 s de margem para evitar uso de token expirando
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));

    return token;
  }

  /// Invalida o cache para forçar novo login no próximo uso.
  void invalidateToken() {
    _cachedToken = null;
    _tokenExpiry = null;
  }
}
