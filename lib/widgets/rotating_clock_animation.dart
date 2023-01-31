import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

class RotatingClockAnimation extends StatefulWidget {
  final Size size;
  const RotatingClockAnimation({super.key, required this.size});

  @override
  State<RotatingClockAnimation> createState() => _RotatingClockAnimationState();
}

class _RotatingClockAnimationState extends State<RotatingClockAnimation> {
  late final Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height,
      width: widget.size.height,
      child: CustomPaint(
        painter: ClockPainter(),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();
  @override
  void paint(Canvas canvas, Size size) {
    var minLength = min(size.width, size.height);
    var x = size.width / 2;
    var y = size.height / 2;
    var center = Offset(x, y);
    var radius = minLength / 2;

    // painters
    var paintBrush = Paint();
    paintBrush.color = const Color(0xff444974);
    var paintBrush2 = Paint();
    paintBrush2.color = const Color(0xffeaecff);
    paintBrush2.style = PaintingStyle.stroke;
    paintBrush2.strokeWidth = 16;
    var paintBrush3 = Paint();
    paintBrush3.color = const Color(0xffeaecff);
    paintBrush3.style = PaintingStyle.fill;
    paintBrush3.strokeWidth = 13;

    // min hour and second
    var paintBrush4 = Paint();
    paintBrush4.color = Colors.orange[300]!;
    paintBrush4.style = PaintingStyle.stroke;
    paintBrush4.strokeWidth = 10;
    paintBrush4.strokeCap = StrokeCap.round;
    var paintBrush5 = Paint()..color = const Color(0xffeaecff);
    paintBrush5.style = PaintingStyle.stroke;
    paintBrush5.strokeWidth = 13;
    paintBrush5.strokeCap = StrokeCap.round;
    paintBrush5.shader =
        const LinearGradient(colors: [Colors.lightBlue, Colors.pink])
            .createShader(Rect.fromCircle(center: center, radius: radius));
    var paintBrush6 = Paint()..color = const Color(0xffeaecff);
    paintBrush6.style = PaintingStyle.stroke;
    paintBrush6.strokeWidth = 12;
    paintBrush6.strokeCap = StrokeCap.round;
    paintBrush6.shader =
        const LinearGradient(colors: [Colors.lightBlue, Colors.pink])
            .createShader(Rect.fromCircle(center: center, radius: radius));

    // cordinates

    var fourthCod = Offset(
        x + 0.7 * size.height / 2 * cos(90 + dateTime.second * 6 * pi / 180),
        y + 0.7 * size.height / 2 * sin(90 + dateTime.second * 6 * pi / 180));
    var fifthCod = Offset(x + 60 * cos(90 + dateTime.minute * 6 * pi / 180),
        y + 0.6 * size.height / 2 * sin(90 + dateTime.minute * 6 * pi / 180));
    var sixthCod = Offset(x + 50 * cos(90 + dateTime.hour * 6 * pi / 180),
        y + 0.5 * size.height / 2 * sin(90 + dateTime.hour * 6 * pi / 180));

    var outer = radius + 16;
    var inner = radius + 10;
    var paint = Paint();
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 1;
    paint.color = Colors.white;

    for (int i = 0; i <= 360; i += 12) {
      var x1 = x + outer * cos(i * pi / 180);
      var y1 = x + outer * sin(i * pi / 180);
      var x2 = x + inner * cos(i * pi / 180);
      var y2 = x + inner * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }

    //draw

    canvas.drawCircle(center, radius - 5, paintBrush);
    canvas.drawCircle(center, radius - 5, paintBrush2);
    canvas.drawLine(center, fourthCod, paintBrush4);
    canvas.drawLine(center, fifthCod, paintBrush5);
    canvas.drawLine(center, sixthCod, paintBrush6);
    canvas.drawCircle(center, 16, paintBrush3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
