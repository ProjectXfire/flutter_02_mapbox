import 'package:flutter/material.dart';

class StartMarker extends CustomPainter {
  final int duration;
  final String destination;

  StartMarker({required this.duration, required this.destination});

  @override
  void paint(Canvas canvas, Size size) {
    final blackPincel = Paint()..color = Colors.black;
    final whitePincel = Paint()..color = Colors.white;
    const double blackRadio = 20;
    const double whiteRadio = 10;

    // Draw circles
    canvas.drawCircle(
        Offset(blackRadio, size.height - blackRadio), blackRadio, blackPincel);
    canvas.drawCircle(
        Offset(blackRadio, size.height - blackRadio), whiteRadio, whitePincel);

    // Draw box
    final path = Path();

    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);
    canvas.drawShadow(path, Colors.black, 10, false);
    canvas.drawPath(path, whitePincel);

    const blackBox = Rect.fromLTRB(40, 20, 110, 100);
    canvas.drawRect(blackBox, blackPincel);

    // Text - Number
    final textNumber = TextSpan(
        text: duration > 999 ? '+999' : '$duration',
        style: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold));
    final numberPainter = TextPainter(
        text: textNumber,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: 70, maxWidth: 70);
    numberPainter.paint(canvas, const Offset(40, 30));

    // Text - "Min"
    const textMinutes = TextSpan(
        text: "Min",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold));
    final minutesPainter = TextPainter(
        text: textMinutes,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: 70, maxWidth: 70);
    minutesPainter.paint(canvas, const Offset(40, 60));

    // Text - Description

    final textDescription = TextSpan(
        text: destination,
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold));
    final descriptionPainter = TextPainter(
        text: textDescription,
        maxLines: 2,
        ellipsis: "...",
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left)
      ..layout(minWidth: size.width - 135, maxWidth: size.width - 135);
    final double offsetY = destination.length > 21 ? 35 : 48;
    descriptionPainter.paint(canvas, Offset(120, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }
}
