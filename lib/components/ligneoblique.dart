import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';


class LineAndStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 200), // Taille du canvas
      painter: LineAndIconPainter(),
    );
  }
}

class LineAndIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(500, 180), // Taille du canvas
      painter: LineAndIconPainter(),
    );
  }
}

class LineAndIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red // Couleur de la ligne
      ..strokeWidth = 15 // Épaisseur de la ligne
      ..style = PaintingStyle.stroke; // Style de peinture pour les lignes

    // Dessiner la ligne oblique
    final Offset start = Offset(-40, size.height); // Début de la ligne (coin inférieur gauche)
    final Offset end = Offset(size.width , 30); // Fin de la ligne, décalée pour éviter l'icône

    // Dessiner la ligne
    canvas.drawLine(start, end, paint);

    // Dessiner l'icône après la ligne
    _drawIcon(canvas, size);
  }

  void _drawIcon(Canvas canvas, Size size) {
    final double iconX = size.width / 50; // Position X de l'icône
    final double iconY = size.height / 6; // Position Y de l'icône
    final double iconSize = 50.0; // Taille de l'icône

    final Paint paint = Paint();
    final icon = Icons.star;
    final textStyle = TextStyle(fontSize: iconSize, color: Colors.amber);

    final textSpan = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: textStyle.copyWith(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // Positionner l'icône
    final Offset offset = Offset(
      iconX - textPainter.width / 2,
      iconY - textPainter.height / 2,
    );

    // Dessiner l'icône sur le canvas
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}