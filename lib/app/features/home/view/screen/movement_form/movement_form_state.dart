import 'package:padaria_cjm2/app/features/home/model/movements.dart';

abstract class MovementFormState {}

class MovementFormInitial extends MovementFormState {}

class MovementFormLoading extends MovementFormState {}

class MovementFormSuccess extends MovementFormState {}

class MovementFormError extends MovementFormState {
  final String message;
  MovementFormError(this.message);
}
