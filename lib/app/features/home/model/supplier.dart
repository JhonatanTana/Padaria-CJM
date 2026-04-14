class Supplier {
  String? id;
  String name;

  Supplier({this.id, required this.name});

  Supplier.fromMap(Map<String, dynamic> map, String id)
      :  id = id,
        name = map['name'];


  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}