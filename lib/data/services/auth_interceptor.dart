import 'package:api_produtos/data/services/auth_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Não adiciona Bearer no próprio endpoint de auth (usa Basic Auth)
    if (options.path.contains('/auth/token')) {
      return handler.next(options);
    }

    try {
      final token = await _authService.getToken();
      options.headers['Authorization'] = 'Bearer $token';
    } catch (_) {
      // Segue sem token; o servidor retornará 401
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('/auth/token')) {
      // Token expirado: invalida cache e tenta uma única vez
      _authService.invalidateToken();
      try {
        final token = await _authService.getToken();
        final opts = err.requestOptions
          ..headers['Authorization'] = 'Bearer $token';

        final response = await Dio().fetch(opts);
        return handler.resolve(response);
      } catch (_) {
        // Se falhar novamente, propaga o erro original
      }
    }
    return handler.next(err);
  }
}
