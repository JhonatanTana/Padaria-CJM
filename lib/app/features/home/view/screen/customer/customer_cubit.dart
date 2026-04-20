import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/customer.dart';
import '../../../services/customer_service.dart';
import 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerService _service = CustomerService();
  StreamSubscription<List<Customer>>? _subscription;
  List<Customer> _allCustomers = [];

  CustomerCubit() : super(CustomerInitial());

  void loadCustomers() {
    emit(CustomerLoading());
    _subscription?.cancel();
    _subscription = _service.getCustomers().listen((newList) {
      _allCustomers = newList;
      _emitLoadedState();
    }, onError: (e) {
      emit(CustomerError(e.toString()));
    });
  }

  void setSearchQuery(String query) {
    if (state is CustomerLoaded) {
      final currentState = state as CustomerLoaded;
      emit(currentState.copyWith(searchQuery: query));
      _emitLoadedState();
    }
  }

  void _emitLoadedState() {
    String query = "";
    if (state is CustomerLoaded) {
      query = (state as CustomerLoaded).searchQuery;
    }

    List<Customer> filtered = _allCustomers;
    if (query.isNotEmpty) {
      filtered = _allCustomers.where((customer) {
        return customer.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    emit(CustomerLoaded(customers: filtered, searchQuery: query));
  }

  Future<void> addCustomer(String name, bool canSale) async {
    try {
      final newCustomer = Customer(
        name: name,
        canSale: canSale,
        balance: 0.0,
      );
      await _service.addCustomer(newCustomer);
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _service.updateCustomer(customer);
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _service.deleteCustomer(id);
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
