import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String removeSpecialCharacters(String input) {
  return input.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
}

String? requiredIfEmpty(String? input) {
  if (input == null || input.isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}

/// Valida números com suporte a:
/// - required: se true, vazio gera erro "Campo obrigatório"
/// - allowDecimal: true aceita decimais, false só inteiros
/// - min: valor mínimo permitido (padrão: 1)
///
/// Aceita formato pt-BR: "1.234,56"
String? validatePositiveNumber(
  String? input, {
  bool required = true,
  bool allowDecimal = false,
  num min = 1,
}) {
  final text = input?.trim() ?? '';

  if (text.isEmpty) {
    return required ? 'Campo obrigatório' : null;
  }

  // Normaliza pt-BR: "1.234,56" -> "1234.56"
  final normalized = text.replaceAll('.', '').replaceAll(',', '.');

  num? value;
  if (allowDecimal) {
    value = double.tryParse(normalized);
  } else {
    // Para inteiros, impedir que "1.5" passe:
    if (normalized.contains('.')) return 'Valor inválido';
    value = int.tryParse(normalized);
  }

  if (value == null) return 'Valor inválido';
  if (value < min) return 'Deve ser maior ou igual a ${min.toString()}';

  return null;
}

bool isValidPhone(String phone) {
  final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

  if (cleanPhone.length < 10 || cleanPhone.length > 11) {
    return false;
  }

  const validDDDs = {
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '21',
    '22',
    '24',
    '27',
    '28',
    '31',
    '32',
    '33',
    '34',
    '35',
    '37',
    '38',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '51',
    '53',
    '54',
    '55',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '69',
    '71',
    '73',
    '74',
    '75',
    '77',
    '79',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '89',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99',
  };

  final ddd = cleanPhone.substring(0, 2);
  if (!validDDDs.contains(ddd)) {
    return false;
  }

  if (cleanPhone.length == 11 && cleanPhone[2] != '9') {
    return false;
  }

  if (RegExp(r'^(\d)\1*$').hasMatch(cleanPhone)) {
    return false;
  }

  return true;
}

bool isValidCEP(String cep) {
  final cleanCep = cep.replaceAll(RegExp(r'[^\d]'), '');

  if (cleanCep.length != 8) {
    return false;
  }

  if (RegExp(r'^(\d)\1{7}$').hasMatch(cleanCep)) {
    return false;
  }

  return true;
}

bool isValidCpf(String cpf) {
  return UtilBrasilFields.isCPFValido(cpf);
}

bool isValidCnpj(String cnpj) {
  return UtilBrasilFields.isCNPJValido(cnpj);
}

bool isValidDocument(String input, {int minLength = 6}) {
  final clean = input.replaceAll(RegExp(r'[^\d]'), '');

  if (clean.length < minLength) {
    return false;
  }

  if (!RegExp(r'^\d+$').hasMatch(clean)) {
    return false;
  }

  if (RegExp(r'^(\d)\1*$').hasMatch(clean)) {
    return false;
  }

  final ascending = '0123456789';
  if (ascending.contains(clean)) {
    return false;
  }

  final descending = '9876543210';
  if (descending.contains(clean)) {
    return false;
  }

  return true;
}

String formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('dd/MM/yyyy').format(date);
}

DateTime? parseDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return null;
  try {
    return DateFormat('dd/MM/yyyy').parse(dateString);
  } catch (e) {
    return null;
  }
}

/// Parse de data no formato MM/yyyy (mês/ano)
/// Retorna o primeiro dia do mês
DateTime? parseMonthYear(String? dateString) {
  if (dateString == null || dateString.isEmpty) return null;
  try {
    return DateFormat('MM/yyyy').parse(dateString);
  } catch (e) {
    return null;
  }
}

/// Formata uma data no formato MM/yyyy (mês/ano)
String formatMonthYear(DateTime? date) {
  if (date == null) return '';
  return DateFormat('MM/yyyy').format(date);
}

String formatCurrencyBR(double value, {bool withSymbol = true}) {
  final formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: withSymbol ? 'R\$' : '',
  );
  return formatter.format(value).trim();
}

double parseCurrencyBR(String input) {
  if (input.isEmpty) return 0.0;

  String sanitized = input.trim();

  sanitized = sanitized.replaceAll('.', '');

  sanitized = sanitized.replaceAll(',', '.');

  return double.tryParse(sanitized) ?? 0.0;
}

String digitsOnly(String s) => s.replaceAll(RegExp(r'[^\d]'), '');

bool isLikelyValidBrMobile(String raw) {
  final d = digitsOnly(raw);
  if (d.length == 13 && d.startsWith('55')) {
    // 55 + DDD(2) + 9 + 8 dígitos = 13
    return d[4] == '9';
  }
  if (d.length == 11) {
    // DDD(2) + 9 + 8 dígitos
    return d[2] == '9';
  }
  return false;
}

String normalizeBrazilPhone(String raw, {String defaultCountryCode = '55'}) {
  var d = digitsOnly(raw);

  // já vem com +55 ou 55
  if (d.startsWith(defaultCountryCode)) {
    return d;
  }

  // Se vier apenas com DDD+numero (10/11 dígitos), prefixa 55
  if (d.length == 10 || d.length == 11) {
    return '$defaultCountryCode$d';
  }

  // Caso já venha em E.164 curto (pouco provável), retorna como está
  return d;
}

Future<void> openWhatsApp({
  required String phoneRaw,
  required String message,
  void Function(String msg)? onError,
  bool copyOnFail = true,
}) async {
  final phoneE164 = normalizeBrazilPhone(phoneRaw);

  if (!isLikelyValidBrMobile(phoneRaw) && !isLikelyValidBrMobile(phoneE164)) {
    if (copyOnFail) {
      await Clipboard.setData(ClipboardData(text: message));
      onError?.call(
        'Número inválido. Mensagem copiada para a área de transferência.',
      );
    } else {
      onError?.call('Número de WhatsApp inválido.');
    }
    return;
  }

  final url = Uri.https('api.whatsapp.com', '/send', {
    'phone': phoneE164,
    'text': message,
  });

  try {
    final ok = await launchUrl(
      url,
      mode: kIsWeb
          ? LaunchMode.externalApplication
          : LaunchMode.externalApplication,
    );

    if (ok) return;
  } on Exception catch (_) {
    // Ignora exceção - fallback tratado abaixo
  }

  onError?.call('Não foi possível abrir o WhatsApp.');
  if (copyOnFail) {
    await Clipboard.setData(ClipboardData(text: message));
    onError?.call('Mensagem copiada para a área de transferência.');
  }
}

// ──────────────────────────── Estados Brasileiros ─────────────────────────────

const Map<String, String> kBrazilianStates = {
  'AC': 'Acre',
  'AL': 'Alagoas',
  'AP': 'Amapá',
  'AM': 'Amazonas',
  'BA': 'Bahia',
  'CE': 'Ceará',
  'DF': 'Distrito Federal',
  'ES': 'Espírito Santo',
  'GO': 'Goiás',
  'MA': 'Maranhão',
  'MT': 'Mato Grosso',
  'MS': 'Mato Grosso do Sul',
  'MG': 'Minas Gerais',
  'PA': 'Pará',
  'PB': 'Paraíba',
  'PR': 'Paraná',
  'PE': 'Pernambuco',
  'PI': 'Piauí',
  'RJ': 'Rio de Janeiro',
  'RN': 'Rio Grande do Norte',
  'RS': 'Rio Grande do Sul',
  'RO': 'Rondônia',
  'RR': 'Roraima',
  'SC': 'Santa Catarina',
  'SP': 'São Paulo',
  'SE': 'Sergipe',
  'TO': 'Tocantins',
};

List<String> getBrazilianStateUFs() => kBrazilianStates.keys.toList();

String? getStateName(String uf) => kBrazilianStates[uf.toUpperCase().trim()];

String? getStateUF(String name) {
  final normalized = name.trim().toLowerCase();
  return kBrazilianStates.entries
      .firstWhere(
        (e) => e.value.toLowerCase() == normalized,
        orElse: () => const MapEntry('', ''),
      )
      .key
      .nullIfEmpty();
}

bool isValidStateUF(String uf) =>
    kBrazilianStates.containsKey(uf.toUpperCase().trim());

List<({String uf, String name})> getBrazilianStatesForDropdown() =>
    kBrazilianStates.entries.map((e) => (uf: e.key, name: e.value)).toList();

// Extensão auxiliar interna — evita checagem de string vazia repetida.
extension _StringX on String {
  String? nullIfEmpty() => isEmpty ? null : this;
}
