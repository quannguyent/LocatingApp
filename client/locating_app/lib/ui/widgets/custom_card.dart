import 'package:flutter/material.dart';
import '../../res/resources.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  CustomCard({
    @required this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.2),
            offset: Offset(1.1, 1.1),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: child,
      padding: padding,
      margin: margin,
    );
  }
}
