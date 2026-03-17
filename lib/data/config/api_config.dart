class ApiConfig {
  static const String baseUrl = 'https://api-loja-virtual.multsistem.com.br';

  /// Credenciais Basic Auth para gerar o JWT (POST /auth/token)
  static const String basicAuthUser = 'admin_main';
  static const String basicAuthPassword = 'x7Km9Pv2!Lq8*Ws4';

  /// Slug do tenant (informado no body de /auth/token)
  static const String slug = 'demo';
}
