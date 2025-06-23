class Customer {
  final int id;
  final String name;
  final String? phoneNumber;
  final String? address;
  final String? internetSpeed;
  final String? unit;
  final String? price;

  Customer({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.address,
    this.internetSpeed,
    this.unit,
    this.price,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      internetSpeed: json['internet_speed']?.toString(),
      unit: json['unit'],
      price: json['price']?.toString(),
    );
  }
}
