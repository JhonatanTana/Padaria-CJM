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
              .map((doc) => Movement.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> addMovement(String customerId, Movement movement) async {
    await _storage
        .collection('clientes')
        .doc(customerId)
        .collection('movimentacoes')
        .add(movement.toJSON());
  }

  Future<void> updateMovement(String customerId, Movement movement) async {
    await _storage
        .collection('clientes')
        .doc(customerId)
        .collection('movimentacoes')
        .doc(movement.id)
        .update(movement.toJSON());
  }

  Future<void> deleteMovement(String customerId, String movementId) async {
    await _storage
        .collection('clientes')
        .doc(customerId)
        .collection('movimentacoes')
        .doc(movementId)
        .delete();
  }
}
