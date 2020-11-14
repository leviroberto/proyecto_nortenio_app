import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/responsive.dart';

class MenuSuperiorMeses extends StatefulWidget {
  MenuSuperiorMeses({Key key}) : super(key: key);

  @override
  _MenuSuperiorMesesState createState() => _MenuSuperiorMesesState();
}

class _MenuSuperiorMesesState extends State<MenuSuperiorMeses> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Responsive rosponsive = Responsive.of(context);
    final double heightkSize = rosponsive.widthPercent(110);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: heightkSize * 0.10,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {}),
                  );
                });
              },
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Container(
                  width: 110,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: selectedIndex == index
                        ? Colores.colorButton
                        : Colores.colorBorder,
                  ),
                  child: Center(
                    child: Text(
                      "Septiembre",
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedIndex == index
                            ? Colores.bodyColor
                            : Colores.colorNegro,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
