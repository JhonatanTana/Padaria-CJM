import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_search.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 8,
            children: [
              AppSearch(
                title: "Pesquisar fornecedor",
              ),
            ],
          )
      )
    );
  }
}
