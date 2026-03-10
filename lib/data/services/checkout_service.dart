import 'package:dio/dio.dart';

/// TODO: Substituir as URLs pelos endpoints reais quando disponíveis.
class CheckoutService {
  final Dio _dio;
  CheckoutService(this._dio);

  /// Busca o cliente pelo CPF.
  /// Retorna 200 + dados se encontrado, 404 se não cadastrado.
  Future<Response> getCustomerByCpf(String cpf) async {
    return await _dio.get('https://your-api.com/api/customers/$cpf');
  }

  /// Cadastra um novo cliente com endereço.
  Future<Response> registerCustomer(Map<String, dynamic> customerJson) async {
    return await _dio.post(
      'https://your-api.com/api/customers',
      data: customerJson,
    );
  }

  /// Busca as informações da empresa (incluindo número do WhatsApp).
  /// Esperado: { "whatsapp": "5585999999999", "name": "Nome da Empresa" }
  Future<Response> getCompanyInfo() async {
    return await _dio.get('https://your-api.com/api/company');
  }
}
