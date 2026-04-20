import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movement_form/movement_form_viewmodel.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_button.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_dropdown.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_radio.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../widgets/app_top_bar.dart';

class MovementFormScreen extends StatefulWidget {
  const MovementFormScreen({super.key});

  @override
  State<MovementFormScreen> createState() => _MovementFormScreenState();
}

class _MovementFormScreenState extends State<MovementFormScreen> {
  String? _paymentMethod;

  Future<void> _selectDate(MovementFormViewModel vm) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      vm.updateDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementFormViewModel>();

    return Scaffold(
      appBar: const AppTopBar(title: "Nova Movimentação"),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 4,
          children: [
            Visibility(
              visible: !vm.isSupplier,
              child: AppRadio<bool>(
                values: const [false, true],
                labels: const ["Venda", "Pagamento"],
                value: vm.isSale,
                onChanged: (value) {
                  vm.isSale = value!;
                },
              ),
            ),

            AppInput(
              label: "Data",
              controller: vm.dateController,
              readOnly: true,
              onTap: () => _selectDate(vm),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.grey.shade800),
            ),

            AppInput(
              label: "Valor",
              keyboardType: TextInputType.number,
              controller: vm.amountController,
              validator: AppInput.combine([
                AppInput.required(),
              ]),
            ),

            AppInput(
              label: "Observações",
              keyboardType: TextInputType.multiline,
              controller: vm.notesController,
            ),

            SizedBox(height: 4,),

            Visibility(
              visible: vm.isSale || vm.isSupplier,
              child: AppDropdown<String>(
                label: "Forma de Pagamento",
                items: const ["Dinheiro", "Cartão", "Pix"],
                value: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                    vm.paymentMethod = value;
                  });
                },
                itemLabel: (item) => item,
              ),
            ),

            const Spacer(),
            
            AppButton(
              text: "Salvar",
              onPressed: () => vm.onSubmit(),
            )
          ],
        ),
      ),
    );
  }
}
