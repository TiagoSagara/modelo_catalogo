import 'package:api_produtos/data/services/checkout_service.dart';
import 'package:api_produtos/domain/models/checkout_model.dart';
import 'package:dio/dio.dart';

class CheckoutRepository {
  final CheckoutService _service;
  CheckoutRepository(this._service);

  /// Retorna o [CustomerModel] se o CPF for encontrado, ou null se não cadastrado.
  /// Lança exceção em caso de erro de rede.
  Future<CustomerModel?> findCustomerByCpf(String cpf) async {
    try {
      final response = await _service.getCustomerByCpf(cpf);
      if (response.statusCode == 200 && response.data != null) {
        return CustomerModel.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Cadastra um novo cliente e retorna o modelo criado.
  Future<CustomerModel> registerCustomer(CustomerModel customer) async {
    final response = await _service.registerCustomer(customer.toJson());
    return CustomerModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Retorna o número de WhatsApp da empresa no formato internacional (ex: 5585999999999).
  Future<String> getCompanyWhatsApp() async {
    try {
      final response = await _service.getCompanyInfo();
      return response.data['whatsapp'] as String;
    } catch (_) {
      // TODO: Remover fallback quando o endpoint estiver disponível.
      return '5585999999999';
    }
  }
}
