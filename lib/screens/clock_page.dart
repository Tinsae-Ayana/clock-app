import 'dart:async';
import 'package:clock_app/widgets/rotating_clock_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({
    Key? key,
    required this.height,
    required this.timeZoneString,
  }) : super(key: key);

  final double height;
  final String timeZoneString;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Clock',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            SizedBox(height: height * 0.05),
            const DigitalClock(),
            SizedBox(height: height * 0.07),
            Container(
                alignment: Alignment.center,
                child: const RotatingClockAnimation(
                  size: Size(180, 180),
                )),
            SizedBox(height: height * 0.07),
            const Text('Timezone',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white)),
            Row(
              children: [
                const Icon(Icons.language, color: Colors.white),
                const SizedBox(width: 5),
                Text("UTC $timeZoneString",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DigitalClock extends StatefulWidget {
  const DigitalClock({
    Key? key,
  }) : super(key: key);

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late final Timer timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
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
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);
    String fromattedDate = DateFormat('EEE, d MMM').format(now);
    return Column(
      children: [
        Text(formattedTime,
            style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        Text(fromattedDate,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.white)),
      ],
    );
  }
}
