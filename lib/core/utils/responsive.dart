import 'package:flutter/material.dart';

class Responsive {
  static const double _breakpoint = 600;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _breakpoint;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _breakpoint;
}

class ConstrainedContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ConstrainedContent({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.maxWidth = 800,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
