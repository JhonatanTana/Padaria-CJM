import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/features/home/services/movements_service.dart';
import '../../../model/movements.dart';
import 'home_state.dart';
import 'home_screen.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovementsService service = MovementsService();
  List<Movement> _allMovements = [];

  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      _allMovements = await service.getAllMovements();
      _calculateAndEmit(Filters.day);
    } catch (e) {
      emit(HomeError("Erro ao carregar dados"));
    }
  }

  void _calculateAndEmit(Filters filter) {
    double amountFiados = 0;
    double amountRecebimentos = 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<Movement> filteredMovements = _allMovements.where((m) {
      final mDate = m.date.toDate();
      final movementDate = DateTime(mDate.year, mDate.month, mDate.day);

      switch (filter) {
        case Filters.day:
          return movementDate.isAtSameMomentAs(today);
        case Filters.week:
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          return movementDate.isAfter(weekStart.subtract(const Duration(seconds: 1)));
        case Filters.month:
          return mDate.month == now.month && mDate.year == now.year;
        case Filters.all:
          return true;
      }
    }).toList();

    for (var m in filteredMovements) {
      if (m.isPayment) {
        amountRecebimentos += m.amount.abs();
      } else {
        amountFiados += m.amount;
      }
    }

    emit(HomeLoaded(
      filter: filter,
      amountFiados: amountFiados,
      amountRecebimentos: amountRecebimentos,
    ));
  }

  void changeFilter(Filters newFilter) {
    if (state is HomeLoaded) {
      _calculateAndEmit(newFilter);
    }
  }
}
