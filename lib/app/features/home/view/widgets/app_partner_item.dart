import 'package:flutter/material.dart';

class AppPartnerItem extends StatelessWidget {
  final String name;
  final String balance;
  final bool canSale;

  const AppPartnerItem({
    super.key,
    required this.name,
    required this.balance,
    this.canSale = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 12,
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  /*CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 117, 119, 121),
                  ),*/
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Color(0xFF005A6F),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        balance,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              Row(
                spacing: 8,
                children: [
                  Visibility(
                    visible: !canSale,
                    child: Badge(
                      backgroundColor: const Color(0xFFFFE5E7), // vermelho bem claro
                      textColor: const Color(0xFFD7263D),       // vermelho forte
                      label: Text(
                        "NÃO VENDER",
                        style: TextStyle(
                          fontSize: 9
                        )),
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Icon(Icons.chevron_right)
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
