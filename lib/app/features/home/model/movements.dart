import 'package:cloud_firestore/cloud_firestore.dart';

class Movements {
  Timestamp date;
  bool isPayment;
  double amount;

  Movements({required this.date, required this.isPayment, required this.amount});

  Movements.fromMap(Map<String, dynamic> map)
    : date = map['data'],
    isPayment = map['pagamento'],
    amount = map['valor'];

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = date;
    data['pagamento'] = isPayment;
    data['valor'] = amount;
    return data;
  }
}