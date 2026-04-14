import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:padaria_cjm2/app/features/home/model/supplier.dart';

class SupplierService {
  final FirebaseFirestore _storage = FirebaseFirestore.instance;
  final String _table = "fornecedores";

  Stream<List<Supplier>> getSuppliers() {
    return _storage.collection(_table).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Supplier.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<Supplier?> getSupplierById(String id) async {
    return await _storage.collection(_table).doc(id).get().then((doc) {
      if (doc.exists) {
        return Supplier.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  Future<void> addSupplier(Supplier customer) async {
    await _storage.collection(_table).add(customer.toJSON());
  }

  Future<void> updateSupplier(Supplier customer) async {
    await _storage.collection(_table).doc(customer.id).update(customer.toJSON());
  }

  Future<void> deleteSupplier(String id) async {
    await _storage.collection(_table).doc(id).delete();
  }

  Future<void> updateBalance(String id, double balance) {
    return _storage.collection(_table).doc(id).update({'balance': balance});
  }
}