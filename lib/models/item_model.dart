class Item {
  final String? id;
  final String? name;
  final String? deliveryDriver;
  String? status;
  bool? confirmed;
  bool? delivered;
  String? CustomerName;

  Item(
      {this.id,
      this.name,
      this.deliveryDriver,
      this.confirmed,
      this.delivered,
      this.status});
  
  // set customer name
  void setCustomerName(String name) {
    CustomerName = name;
  }
  

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
        "status": status,
      };

  Item.fromSnapshot(snapshot)
      : id = snapshot.id,
        name = snapshot.data()['name'],
        deliveryDriver = snapshot.data()['deliveryDriver'],
        confirmed = snapshot.data()['confirmed'],
        delivered = snapshot.data()['delivered'],
        status = snapshot.data()['status'];
}
