import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';
import 'package:provider/provider.dart';

import '../../../model/customer.dart';
import 'customer_viewmodel.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerViewModel>();

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            TextFormField(
              onChanged: vm.setSearchQuery,
              decoration: const InputDecoration(
                label: Text("Procurar cliente"),
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.customers.length,
                itemBuilder: (context, index) {
                  Customer customer = vm.customers[index];

                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: customer.name, 
                          style: TextStyle(
                            color: customer.canSale ? Colors.black : Colors.red,
                          )
                        ),
                        AppText(
                          text: vm.currencyFormatter(customer.balance),
                          style: TextStyle(
                            color: customer.canSale ? Colors.black : Colors.red,
                          )
                        ),
                      ],
                    ),
                    onTap: () => Navigator.pushNamed(context, AppRouter.movements, arguments: customer.id),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }
}
