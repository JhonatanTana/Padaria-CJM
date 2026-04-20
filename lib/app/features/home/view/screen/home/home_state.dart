import 'package:padaria_cjm2/app/features/home/view/screen/home/home_screen.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final Filters filter;
  final double amountFiados;
  final double amountRecebimentos;

  HomeLoaded({
    required this.filter,
    required this.amountFiados,
    required this.amountRecebimentos,
  });

  HomeLoaded copyWith({
    Filters? filter,
    double? amountFiados,
    double? amountRecebimentos,
  }) {
    return HomeLoaded(
      filter: filter ?? this.filter,
      amountFiados: amountFiados ?? this.amountFiados,
      amountRecebimentos: amountRecebimentos ?? this.amountRecebimentos,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
