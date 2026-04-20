import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/movements.dart';
import '../../../services/customer_service.dart';
import '../../../services/supplier_service.dart';
import '../../../services/movements_service.dart';
import 'movements_state.dart';

class MovementsCubit extends Cubit<MovementsState> {
  final CustomerService _customerService = CustomerService();
  final SupplierService _supplierService = SupplierService();
  final MovementsService _service = MovementsService();

  final String partnerId;
  final bool isSupplier;

  StreamSubscription<List<Movement>>? _subscription;

  MovementsCubit({required this.partnerId, required this.isSupplier})
      : super(MovementsInitial());

  void loadData() async {
    emit(MovementsLoading());

    try {
      final movementsFuture = _service.getMovementsByPartnerId(partnerId, isSupplier).first;
      
      dynamic partner;
      if (isSupplier) {
        partner = await _supplierService.getSupplierById(partnerId);
      } else {
        partner = await _customerService.getCustomerById(partnerId);
      }

      final initialMovements = await movementsFuture;
      
      emit(MovementsLoaded(
        movements: initialMovements,
        customer: !isSupplier ? partner : null,
        supplier: isSupplier ? partner : null,
        isSupplier: isSupplier,
      ));

      // Inicia o listener em tempo real
      _subscription?.cancel();
      _subscription = _service.getMovementsByPartnerId(partnerId, isSupplier).listen((newList) {
        if (state is MovementsLoaded) {
          final currentState = state as MovementsLoaded;
          List<Movement> sortedList = List.from(newList);
          sortedList.sort((a, b) => b.date.compareTo(a.date));
          emit(currentState.copyWith(movements: sortedList));
        }
      });

    } catch (e) {
      emit(MovementsError(e.toString()));
    }
  }

  Future<void> deleteMovement(Movement movement) async {
    try {
      await _service.deleteMovement(partnerId, isSupplier, movement.id!);
      
      // Atualizar saldo
      if (isSupplier) {
        final supplier = (state as MovementsLoaded).supplier!;
        supplier.balance -= movement.amount;
        await _supplierService.updateBalance(supplier.id!, supplier.balance);
      } else {
        final customer = (state as MovementsLoaded).customer!;
        customer.balance -= movement.amount;
        await _customerService.updateBalance(customer.id!, customer.balance);
      }
    } catch (e) {
      emit(MovementsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
