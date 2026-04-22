class Supplier {
  String? id;
  String name;
  String category;
  double balance;

  Supplier({this.id, required this.name, required this.balance, required this.category});

  Supplier.fromMap(Map<String, dynamic> map, String this.id)
      :  name = map['name'],
        category = map['category'],
        balance = map['balance'];


  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['category'] = category;
    data['balance'] = balance;
    return data;
  }
}