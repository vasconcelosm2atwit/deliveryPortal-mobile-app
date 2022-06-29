class Item {
  final String? id;
  final String? name;
  final String? deliveryDriver;
  bool? confirmed;
  bool? delivered;

  Item({
    this.id,
    this.name,
    this.deliveryDriver,
    this.confirmed,
    this.delivered,
  });


  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    name: json["name"],
    deliveryDriver: json["deliveryDriver"],
    confirmed: json["confirmed"],
    delivered: json["delivered"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "deliveryDriver": deliveryDriver,
    "confirmed": confirmed,
    "delivered": delivered,
  };

  Item.fromSnapshot(snapshot)
    : id = snapshot.id,
      name = snapshot.data()['name'],
      deliveryDriver = snapshot.data()['deliveryDriver'],
      confirmed = snapshot.data()['confirmed'],
      delivered = snapshot.data()['delivered'];
}