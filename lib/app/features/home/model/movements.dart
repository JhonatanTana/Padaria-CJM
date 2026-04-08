import 'package:cloud_firestore/cloud_firestore.dart';

class Movement {
  Timestamp date;
  bool isPayment;
  double amount;
  String? notes;

  Movement({required this.date, required this.isPayment, required this.amount, this.notes});

  Movement.fromMap(Map<String, dynamic> map)
    : date = map['data'],
    isPayment = map['pagamento'],
    amount = map['valor'],
    notes = map['notas'];

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = date;
    data['pagamento'] = isPayment;
    data['valor'] = amount;
    data['notas'] = notes;
    return data;
  }
}