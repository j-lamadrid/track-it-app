import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);

      var pageAnimation = FadeTransition(opacity: animation, child: child);

      return SlideTransition(position: offsetAnimation, child: pageAnimation);
    },
  );
}
