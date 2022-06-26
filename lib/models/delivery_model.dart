class Delivery{
  String? id;
  String? name;
  String? address;
  String? phone;
  bool? completed;

  // scanned? started? 
  
  Delivery({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.completed
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    id: json["id"],
    name: json["name"],
    address: json['address'],
    phone: json["phone"],
    completed: json['completed']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "phone": phone,
    "completed": completed
  };

  Delivery.fromSnapshot(snapshot)
    : id = snapshot.id,
      name = snapshot.data()['name'],
      address = snapshot.data()['address'],
      phone = snapshot.data()['phoneNumber'],
      completed = snapshot.data()['completed'];
}