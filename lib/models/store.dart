class Store {
  final int id;
  final String name;
  final String address1;
  final String address2;
  final double latitude;
  final double longitude;
  final String phone;
  final List<String> category;
  final int cloverCount;
  final String? openTime;
  final String? closeTime;
  final DateTime updatedAt;

  Store({
    required this.id,
    required this.name,
    required this.address1,
    required this.address2,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.category,
    required this.cloverCount,
    this.openTime,
    this.closeTime,
    required this.updatedAt,
  });

  String toKeyString() {
    return "STORE_$id#${updatedAt.toIso8601String()}";
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      address1: json['address1'],
      address2: json['address2'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      phone: json['phone'],
      category: List<String>.from(json['category']),
      cloverCount: json['cloverCount'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
