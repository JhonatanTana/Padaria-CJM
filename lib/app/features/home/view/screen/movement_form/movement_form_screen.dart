import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_button.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_dropdown.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_radio.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_alert_dialog.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../../core/constants/app_colors.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/home_shimmer.dart';
import 'movement_form_cubit.dart';
import 'movement_form_state.dart';
import '../../../model/movements.dart';

class MovementFormScreen extends StatelessWidget {
  final String partnerId;
  final bool isSupplier;
  final Movement? movementToEdit;

  const MovementFormScreen({
    super.key,
    required this.partnerId,
    required this.isSupplier,
    this.movementToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovementFormCubit(
        partnerId: partnerId,
        isSupplier: isSupplier,
        movementToEdit: movementToEdit,
      ),
      child: const MovementFormView(),
    );
  }
}

class MovementFormView extends StatefulWidget {
  const MovementFormView({super.key});

  @override
  State<MovementFormView> createState() => _MovementFormViewState();
}

class _MovementFormViewState extends State<MovementFormView> {
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isPayment = false;
  String? _paymentMethod;
  late Timestamp _selectedTimestamp;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<MovementFormCubit>();
    if (cubit.movementToEdit != null) {
      final m = cubit.movementToEdit!;
      _isPayment = m.isPayment;
      _amountController.text = m.amount.abs().toString();
      _notesController.text = m.notes ?? "";
      _paymentMethod = m.paymentMethod;
      _selectedTimestamp = m.date;
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedTimestamp.toDate());
    } else {
      final brasil = tz.getLocation('America/Sao_Paulo');
      final now = tz.TZDateTime.now(brasil);
      final date = tz.TZDateTime(brasil, now.year, now.month, now.day, now.hour, now.minute, now.second);
      _dateController.text = DateFormat('dd/MM/yyyy').format(date);
      _selectedTimestamp = Timestamp.fromDate(date);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTimestamp.toDate(),
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
      setState(() {
        final brasil = tz.getLocation('America/Sao_Paulo');
        final date = tz.TZDateTime(brasil, picked.year, picked.month, picked.day);
        _selectedTimestamp = Timestamp.fromDate(date);
        _dateController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovementFormCubit>();

    return BlocListener<MovementFormCubit, MovementFormState>(
      listener: (context, state) {
        if (state is MovementFormSuccess) {
          Navigator.pop(context);
        }
        if (state is MovementFormError) {
          AppAlertDialog.show(
            context: context,
            title: "Erro",
            content: state.message,
            isError: true,
          );
        }
      },
      child: Scaffold(
        appBar: const AppTopBar(title: "Nova Movimentação"),
        backgroundColor: AppColors.background,
        body: BlocBuilder<MovementFormCubit, MovementFormState>(
          builder: (context, state) {
            if (state is MovementFormLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: HomeShimmer(),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                spacing: 4,
                children: [
                  Visibility(
                    visible: !cubit.isSupplier,
                    child: AppRadio<bool>(
                      values: const [false, true],
                      labels: const ["Venda", "Pagamento"],
                      value: _isPayment,
                      onChanged: (value) {
                        setState(() {
                          _isPayment = value!;
                        });
                      },
                    ),
                  ),

                  AppInput(
                    label: "Data",
                    controller: _dateController,
                    readOnly: true,
                    onTap: _selectDate,
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.grey.shade800),
                  ),

                  AppInput(
                    label: "Valor",
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    validator: AppInput.combine([
                      AppInput.required(),
                    ]),
                  ),

                  AppInput(
                    label: "Observações",
                    keyboardType: TextInputType.multiline,
                    controller: _notesController,
                  ),

                  const SizedBox(height: 4,),

                  Visibility(
                    visible: _isPayment || cubit.isSupplier,
                    child: AppDropdown<String>(
                      label: "Forma de Pagamento",
                      items: const ["Dinheiro", "Cartão", "Pix"],
                      value: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value;
                        });
                      },
                      itemLabel: (item) => item,
                    ),
                  ),

                  const Spacer(),
                  
                  AppButton(
                    text: "Salvar",
                    onPressed: () {
                      if (_amountController.text.isNotEmpty) {
                        cubit.submit(
                          isPayment: _isPayment,
                          date: _selectedTimestamp,
                          amount: double.parse(_amountController.text),
                          notes: _notesController.text,
                          paymentMethod: _paymentMethod,
                        );
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
