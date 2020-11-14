import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      height: mediaQuery.size.height * .60,
      color: Colores.bodyColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Ediciones",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
