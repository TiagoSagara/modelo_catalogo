class AddressModel {
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  const AddressModel({
    required this.street,
    required this.number,
    this.complement = '',
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  String get formatted =>
      '$street, $number'
      '${complement.isNotEmpty ? ", $complement" : ""}'
      ' - $neighborhood, $city/$state';

  Map<String, dynamic> toJson() => {
    'street': street,
    'number': number,
    'complement': complement,
    'neighborhood': neighborhood,
    'city': city,
    'state': state,
  };
}

class CustomerModel {
  final String cpf;
  final String name;
  final AddressModel address;

  const CustomerModel({
    required this.cpf,
    required this.name,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final addr = json['address'] as Map<String, dynamic>;
    return CustomerModel(
      cpf: json['cpf'],
      name: json['name'],
      address: AddressModel(
        street: addr['street'],
        number: addr['number'],
        complement: addr['complement'] ?? '',
        neighborhood: addr['neighborhood'],
        city: addr['city'],
        state: addr['state'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'cpf': cpf,
    'name': name,
    'address': address.toJson(),
  };
}
