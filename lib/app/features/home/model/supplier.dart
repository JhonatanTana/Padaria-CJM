class Supplier {
  String? id;
  String name;
  double balance;

  Supplier({this.id, required this.name, required this.balance});

  Supplier.fromMap(Map<String, dynamic> map, String this.id)
      :  name = map['name'],
        balance = map['balance'];


  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['balance'] = balance;
    return data;
  }
}