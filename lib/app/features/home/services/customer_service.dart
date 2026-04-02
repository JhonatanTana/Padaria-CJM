import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/customer.dart';

class CustomerService {
  final FirebaseFirestore _storage = FirebaseFirestore.instance;

  Stream<List<Customer>> getCustomers() {
    return _storage.collection('clientes').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Customer.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<Customer?> getCustomerById(String id) async {
    return await _storage.collection("clientes").doc(id).get().then((doc) {
      if (doc.exists) {
        return Customer.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }
}
