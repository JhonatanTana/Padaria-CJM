import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';

class MovementsService {
  final FirebaseFirestore _storage = FirebaseFirestore.instance;

  Stream<List<Movement>> getMovementsByCustomerId(String customerId) {
    return _storage
        .collection('clientes')
        .doc(customerId)
        .collection('movimentacoes')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Movement.fromMap(doc.data()))
              .toList();
        });
  }
}
