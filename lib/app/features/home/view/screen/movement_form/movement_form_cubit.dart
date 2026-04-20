import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/features/home/model/customer.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/model/supplier.dart';
import 'package:padaria_cjm2/app/features/home/services/movements_service.dart';
import 'package:padaria_cjm2/app/features/home/services/supplier_service.dart';
import 'package:padaria_cjm2/app/features/home/services/customer_service.dart';
import 'movement_form_state.dart';

class MovementFormCubit extends Cubit<MovementFormState> {
  final MovementsService _service = MovementsService();
  final CustomerService _customerService = CustomerService();
  final SupplierService _supplierService = SupplierService();

  final String partnerId;
  final bool isSupplier;
  final Movement? movementToEdit;

  MovementFormCubit({
    required this.partnerId,
    required this.isSupplier,
    this.movementToEdit,
  }) : super(MovementFormInitial());

  Future<void> submit({
    required bool isPayment,
    required Timestamp date,
    required double amount,
    String? notes,
    String? paymentMethod,
  }) async {
    emit(MovementFormLoading());

    try {
      double finalAmount = amount;
      if (isPayment) {
        finalAmount = finalAmount * -1;
      }

      Movement movement = Movement(
        id: movementToEdit?.id,
        isPayment: isPayment,
        date: date,
        amount: finalAmount,
        notes: notes,
        paymentMethod: paymentMethod,
      );

      if (movementToEdit != null) {
        await _service.updateMovement(partnerId, isSupplier, movement);
      } else {
        await _service.addMovement(partnerId, isSupplier, movement);
      }

      await _updateBalance(finalAmount);

      emit(MovementFormSuccess());
    } catch (e) {
      emit(MovementFormError(e.toString()));
    }
  }

  Future<void> _updateBalance(double newAmount) async {
    double oldAmount = movementToEdit?.amount ?? 0.0;
    
    if (isSupplier) {
      Supplier? supplier = await _supplierService.getSupplierById(partnerId);
      if (supplier != null) {
        supplier.balance = (supplier.balance - oldAmount) + newAmount;
        await _supplierService.updateBalance(supplier.id!, supplier.balance);
      }
    } else {
      Customer? customer = await _customerService.getCustomerById(partnerId);
      if (customer != null) {
        customer.balance = (customer.balance - oldAmount) + newAmount;
        await _customerService.updateBalance(customer.id!, customer.balance);
      }
    }
  }
}
