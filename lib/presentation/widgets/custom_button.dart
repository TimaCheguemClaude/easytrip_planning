import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.height = 50.0,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.brightness == Brightness.dark 
        ? Color(0xFF2196F3) // Blue in dark mode
        : Color(0xFF2196F3); // Blue in light mode
    
    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, height),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(color: defaultColor),
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? defaultColor,
        minimumSize: Size(double.infinity, height),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 2,
      ),
      child: child,
    );
  }
}