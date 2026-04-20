import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/segmented_button_options.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_little_card.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_segmented_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            spacing: 8,
            children: [
              AppSegmentedButton(
                selected: Filters.day,
                options: [
                  AppSegmentedButtonOption(value: Filters.day, label: "Dia"),
                  AppSegmentedButtonOption(value: Filters.week, label: "Semana"),
                  AppSegmentedButtonOption(value: Filters.month, label: "Mês"),
                  AppSegmentedButtonOption(value: Filters.all, label: "Tudo"),
                ],
                onSelectionChanged: (value) {  },
              ),

              Row(
                children: [
                  Expanded(
                    child: AppLittleCard(
                      title: "Fiados",
                      icon: Icons.shopping_cart,
                      iconColor: Colors.orange,
                      backgroundIconColor: Colors.orange.shade100,
                      amount: 100,
                    )
                  ),
                  Expanded(
                    child: AppLittleCard(
                      title: "Recebimentos",
                      icon: Icons.attach_money,
                      iconColor: Colors.blue,
                      backgroundIconColor: Colors.blue.shade100,
                      amount: 100,
                    )
                  ),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

enum Filters { day, week, month, all }
