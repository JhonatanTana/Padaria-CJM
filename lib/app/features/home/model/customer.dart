class Customer {
  String? id;
  String name;
  bool canSale;
  double balance;

  Customer({this.id, required this.name, required this.canSale, required this.balance});

  Customer.fromMap(Map<String, dynamic> map, String id)
    :  id = id,
    name = map['name'],
    canSale = map['canSale'],
    balance = map['balance'];


  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['canSale'] = canSale;
    data['balance'] = balance;
    return data;
  }
}
