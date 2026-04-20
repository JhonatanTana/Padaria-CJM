import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/features/home/model/segmented_button_options.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/home/home_cubit.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/home/home_state.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_little_card.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_segmented_button.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/home_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const HomeShimmer();
              }

              if (state is HomeError) {
                return Center(child: Text(state.message));
              }

              if (state is HomeLoaded) {
                return Column(
                  spacing: 8,
                  children: [
                    AppSegmentedButton(
                      selected: state.filter,
                      options: [
                        AppSegmentedButtonOption(value: Filters.day, label: "Dia"),
                        AppSegmentedButtonOption(value: Filters.week, label: "Semana"),
                        AppSegmentedButtonOption(value: Filters.month, label: "Mês"),
                        AppSegmentedButtonOption(value: Filters.all, label: "Tudo"),
                      ],
                      onSelectionChanged: (value) {
                        context.read<HomeCubit>().changeFilter(value);
                      },
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: AppLittleCard(
                            title: "Fiados",
                            icon: Icons.shopping_cart,
                            iconColor: Colors.orange,
                            backgroundIconColor: Colors.orange.shade100,
                            amount: state.amountFiados,
                          )
                        ),
                        Expanded(
                          child: AppLittleCard(
                            title: "Recebimentos",
                            icon: Icons.attach_money,
                            iconColor: Colors.blue,
                            backgroundIconColor: Colors.blue.shade100,
                            amount: state.amountRecebimentos,
                          )
                        ),
                      ],
                    )
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        )
      ),
    );
  }
}

enum Filters { day, week, month, all }
