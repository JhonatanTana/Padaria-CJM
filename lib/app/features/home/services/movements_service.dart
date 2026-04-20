import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';

class MovementsService {
  final FirebaseFirestore _storage = FirebaseFirestore.instance;

  String _getCollection(bool isSupplier) => isSupplier ? "fornecedores" : "clientes";

  Stream<List<Movement>> getMovementsByPartnerId(String partnerId, bool isSupplier) {
    return _storage
        .collection(_getCollection(isSupplier))
        .doc(partnerId)
        .collection('movimentacoes')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Movement.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> addMovement(String partnerId, bool isSupplier, Movement movement) async {
    await _storage
        .collection(_getCollection(isSupplier))
        .doc(partnerId)
        .collection('movimentacoes')
        .add(movement.toJSON());
  }

  Future<void> updateMovement(String partnerId, bool isSupplier, Movement movement) async {
    await _storage
        .collection(_getCollection(isSupplier))
        .doc(partnerId)
        .collection('movimentacoes')
        .doc(movement.id)
        .update(movement.toJSON());
  }

  Future<void> deleteMovement(String partnerId, bool isSupplier, String movementId) async {
    await _storage
        .collection(_getCollection(isSupplier))
        .doc(partnerId)
        .collection('movimentacoes')
        .doc(movementId)
        .delete();
  }

  Future<List<Movement>> getAllMovements() {
    return _storage
        .collection('movimentacoes').get()
        .then((snapshot) {
          return snapshot.docs.map((doc) => Movement.fromMap(doc.data(), doc.id)).toList();
        });
  }
}
