class Cinema {
  final int id;
  final String name;
  final String city;
  final String address;

  Cinema({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
    };
  }
}
