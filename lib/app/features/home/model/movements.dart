import 'package:cloud_firestore/cloud_firestore.dart';

class Movement {
  String? id;
  Timestamp date;
  bool isPayment;
  double amount;
  String? notes;
  String? paymentMethod;

  Movement({this.id, required this.date, required this.isPayment, required this.amount, this.notes, this.paymentMethod});

  Movement.fromMap(Map<String, dynamic> map, String documentId)
    : id = documentId,
    date = map['data'],
    isPayment = map['pagamento'],
    amount = map['valor'],
    notes = map['notas'],
    paymentMethod = map['paymentMethod'];

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = date;
    data['pagamento'] = isPayment;
    data['valor'] = amount;
    data['notas'] = notes;
    data['paymentMethod'] = paymentMethod;
    return data;
  }
}
