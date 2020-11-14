import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeftRightMenuButton extends StatelessWidget {
  final String leftIcon, rightIcon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final Widget rightContente;
  final double fontSize;
  final FontWeight fontWeight;
  const LeftRightMenuButton(
      {Key key,
      this.leftIcon,
      this.rightIcon,
      this.fontSize = 12,
      this.fontWeight,
      this.color,
      this.onPressed,
      this.rightContente,
      this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    if (leftIcon != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SvgPicture.asset(
                          leftIcon,
                          color: this.color,
                          width: 20,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: this.fontSize,
                              color: this.color,
                              fontWeight: this.fontWeight),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (rightIcon != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SvgPicture.asset(
                    rightIcon,
                    color: this.color,
                    width: 15,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
