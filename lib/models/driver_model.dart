

class Driver{
  String? uuid;
  String? name;
  String? phone;
  String? email;
  int? assignedDeliveries;
  int? deliveryCompleted;

  Driver({
    this.uuid,
    this.name,
    this.phone,
    this.email,
    this.assignedDeliveries,
    this.deliveryCompleted,
  });


  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    assignedDeliveries: json["assignedDeliveries"],
    deliveryCompleted: json["deliveryCompleted"],
  );

  // driver to json
  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "email": email,
    "assignedDeliveries": assignedDeliveries,
    "deliveryCompleted": deliveryCompleted,
  };

  Driver.fromSnapshot(snapshot)
    : uuid = snapshot.id,
      name = snapshot.data()['name'],
      email = snapshot.data()['email'],
      phone = snapshot.data()['phoneNumber'],
      assignedDeliveries = snapshot.data()['deliveries_assigned'],
      deliveryCompleted = snapshot.data()['deliveries_completed'];

}


