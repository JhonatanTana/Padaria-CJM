import '../../../model/supplier.dart';

abstract class SupplierState {}

class SupplierInitial extends SupplierState {}

class SupplierLoading extends SupplierState {}

class SupplierLoaded extends SupplierState {
  final List<Supplier> suppliers;
  final String searchQuery;

  SupplierLoaded({
    required this.suppliers,
    this.searchQuery = "",
  });

  SupplierLoaded copyWith({
    List<Supplier>? suppliers,
    String? searchQuery,
  }) {
    return SupplierLoaded(
      suppliers: suppliers ?? this.suppliers,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class SupplierError extends SupplierState {
  final String message;
  SupplierError(this.message);
}
