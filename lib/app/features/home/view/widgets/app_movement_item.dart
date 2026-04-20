import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/core/constants/currency_formatter.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';

import '../../../../core/constants/date_formatter.dart';

class AppMovementItem extends StatelessWidget {
  final bool isSupplier;
  final Movement item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AppMovementItem({super.key, required this.item, this.onTap, this.onLongPress, required this.isSupplier});

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
                backgroundColor: isSupplier ? Colors.grey.shade100 :
                  item.isPayment ? Colors.green.shade100 : Colors.grey.shade100,
                child: Icon(isSupplier ? Icons.receipt :
                    item.isPayment ? Icons.attach_money : Icons.receipt,
                  color: isSupplier ? Colors.grey :
                    item.isPayment ? Colors.green : Colors.grey,
                )
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSupplier ? item.notes ?? '' :
                      item.isPayment ? "Pagamento" : "Venda",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                  color: isSupplier ? Colors.black :
                    item.isPayment ? Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
