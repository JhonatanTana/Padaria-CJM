import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import 'home_screen.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      // Simulando carregamento de dados
      await Future.delayed(const Duration(milliseconds: 500));
      emit(HomeLoaded(
        filter: Filters.day,
        amountFiados: 100.0,
        amountRecebimentos: 100.0,
      ));
    } catch (e) {
      emit(HomeError("Erro ao carregar dados"));
    }
  }

  void changeFilter(Filters newFilter) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      // Aqui poderíamos carregar novos dados baseados no filtro
      emit(currentState.copyWith(filter: newFilter));
    }
  }
}
