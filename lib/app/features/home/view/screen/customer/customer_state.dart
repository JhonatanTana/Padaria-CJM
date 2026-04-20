import '../../../model/customer.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  final String searchQuery;

  CustomerLoaded({
    required this.customers,
    this.searchQuery = "",
  });

  CustomerLoaded copyWith({
    List<Customer>? customers,
    String? searchQuery,
  }) {
    return CustomerLoaded(
      customers: customers ?? this.customers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError(this.message);
}
