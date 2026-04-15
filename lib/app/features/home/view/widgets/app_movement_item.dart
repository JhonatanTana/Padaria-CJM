import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padaria_cjm2/app/core/constants/currency_formatter.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/constants/date_formatter.dart';

class AppMovementItem extends StatelessWidget {
  final Movement item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppMovementItem({super.key, required this.item, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            spacing: 8,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: item.isPayment ? Colors.green.shade100 : Colors.grey.shade100,
                child: Icon(
                  item.isPayment ? Icons.attach_money : Icons.receipt,
                  color: item.isPayment ? Colors.green : Colors.grey,
                )
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.isPayment ? "Pagamento" : "Venda",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormatter.formatToString(item.date.toDate(), true),
                      style: const TextStyle(
                        fontSize: 13
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                CurrencyFormatter.format(item.amount),
                style: TextStyle(
                  fontSize: 15,
                  color: item.isPayment ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
