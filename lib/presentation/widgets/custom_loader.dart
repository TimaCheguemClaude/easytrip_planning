import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const CustomLoader({
    Key? key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Theme.of(context).primaryColor;
    
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
      ),
    );
  }
}