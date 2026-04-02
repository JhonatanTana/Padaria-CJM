import 'package:cloud_firestore/cloud_firestore.dart';

class Movement {
  Timestamp date;
  bool isPayment;
  double amount;

  Movement({required this.date, required this.isPayment, required this.amount});

  Movement.fromMap(Map<String, dynamic> map)
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