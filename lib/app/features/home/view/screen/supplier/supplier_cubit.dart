import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/supplier.dart';
import '../../../services/supplier_service.dart';
import 'supplier_state.dart';

class SupplierCubit extends Cubit<SupplierState> {
  final SupplierService _service = SupplierService();
  StreamSubscription<List<Supplier>>? _subscription;
  List<Supplier> _allSuppliers = [];

  SupplierCubit() : super(SupplierInitial());

  void loadSuppliers() {
    emit(SupplierLoading());
    _subscription?.cancel();
    _subscription = _service.getSuppliers().listen((newList) {
      _allSuppliers = newList;
      _emitLoadedState();
    }, onError: (e) {
      emit(SupplierError(e.toString()));
    });
  }

  void setSearchQuery(String query) {
    if (state is SupplierLoaded) {
      final currentState = state as SupplierLoaded;
      emit(currentState.copyWith(searchQuery: query));
      _emitLoadedState();
    }
  }

  void _emitLoadedState() {
    String query = "";
    if (state is SupplierLoaded) {
      query = (state as SupplierLoaded).searchQuery;
    }

    List<Supplier> filtered = _allSuppliers;
    if (query.isNotEmpty) {
      filtered = _allSuppliers.where((supplier) {
        return supplier.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    emit(SupplierLoaded(suppliers: filtered, searchQuery: query));
  }

  Future<void> addSupplier(String name, String category) async {
    try {
      final newSupplier = Supplier(
        name: name,
        balance: 0.0,
        category: category
      );
      await _service.addSupplier(newSupplier);
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> updateSupplier(Supplier supplier) async {
    try {
      await _service.updateSupplier(supplier);
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> deleteSupplier(String id) async {
    try {
      await _service.deleteSupplier(id);
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
