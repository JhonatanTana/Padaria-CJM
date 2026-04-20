import '../../../model/customer.dart';
import '../../../model/movements.dart';
import '../../../model/supplier.dart';

abstract class MovementsState {}

class MovementsInitial extends MovementsState {}

class MovementsLoading extends MovementsState {}

class MovementsLoaded extends MovementsState {
  final List<Movement> movements;
  final Customer? customer;
  final Supplier? supplier;
  final bool isSupplier;

  MovementsLoaded({
    required this.movements,
    this.customer,
    this.supplier,
    required this.isSupplier,
  });

  double get totalBalance {
    double total = 0.0;
    for (var movement in movements) {
      total += movement.amount;
    }
    return total;
  }

  MovementsLoaded copyWith({
    List<Movement>? movements,
    Customer? customer,
    Supplier? supplier,
    bool? isSupplier,
  }) {
    return MovementsLoaded(
      movements: movements ?? this.movements,
      customer: customer ?? this.customer,
      supplier: supplier ?? this.supplier,
      isSupplier: isSupplier ?? this.isSupplier,
    );
  }
}

class MovementsError extends MovementsState {
  final String message;
  MovementsError(this.message);
}
