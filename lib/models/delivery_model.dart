class Delivery {
  int? step_id;
  String? id;
  String? name;
  String? address;
  String? phone;
  String? status;
  List<String>? items;
  List<double>? latlng;
  int? deliveryStep;
  String? instructions;

  Delivery(
      {this.id, this.name, this.phone, this.address, this.status, this.items});

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        id: json["id"],
        name: json["name"],
        address: json['address'],
        phone: json["phone"],
        status: json['status'],
        items: List<String>.from(json["items"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "completed": status,
        "items": List<dynamic>.from(items!.map((x) => x))
      };

  Delivery.fromSnapshot(snapshot)
      : id = snapshot.id,
        name = snapshot.data()['name'],
        address = snapshot.data()['address'],
        phone = snapshot.data()['phoneNumber'],
        status = snapshot.data()['status'],
        items = List<String>.from(snapshot.data()['items']);
}
