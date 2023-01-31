import 'package:clock_app/screens/alarm_page.dart';
import 'package:clock_app/provider/clock_provider.dart';
import 'package:clock_app/model/enums.dart';
import 'package:clock_app/screens/clock_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin plugin;
  const MainScreen({super.key, required this.plugin});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String timeZoneString = now.timeZoneOffset.toString().split('.').first;
    if (!timeZoneString.startsWith('-')) timeZoneString = '+$timeZoneString';
    return Scaffold(
        backgroundColor: const Color(0xff202f41),
        body: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buitlButton('assets/clock_icon.png', 'clock', MenuType.clock),
                _buitlButton('assets/alarm_icon.png', 'alarm', MenuType.alarm),
              ],
            ),
            const VerticalDivider(color: Colors.white, width: 1),
            Consumer<ClockProvider>(builder: (context, state, child) {
              if (state.menuType == MenuType.alarm) {
                return AlarmPage(
                  plugin: widget.plugin,
                );
              } else {
                return ClockPage(
                    height: height, timeZoneString: timeZoneString);
              }
            }),
          ],
        ));
  }

  IconButton _buitlButton(image, label, menuType) {
    return IconButton(
        iconSize: 85,
        onPressed: () {
          Provider.of<ClockProvider>(context, listen: false)
              .changeMenu(menuType);
        },
        icon: Column(
          children: [
            Image.asset(
              image,
              height: 40,
              width: 40,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ));
  }
}
