import 'package:clock_app/model/alarm.dart';
import 'package:clock_app/provider/clock_provider.dart';
import 'package:clock_app/widgets/alarm_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin plugin;
  const AlarmPage({super.key, required this.plugin});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _alarmTime;
  late String _alarmTimeString;

  @override
  void initState() {
    _alarmTime = DateTime.now();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 25, left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Alarm',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: height * 0.025),
            Consumer<ClockProvider>(builder: (
              context,
              provider,
              widge,
            ) {
              return Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.alarms.length + 1,
                      itemBuilder: ((context, index) {
                        if (index == provider.alarms.length) {
                          return _buildAddAlarm(height, width, context);
                        } else {
                          return AlarmCard(
                            plugin: widget.plugin,
                            height: height,
                            width: width,
                            alarm: provider.alarms[index],
                          );
                        }
                      })));
            })
          ],
        ),
      ),
    );
  }

  Container _buildAddAlarm(double height, double width, context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: height * 0.18,
      width: width * 0.60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xff202f41),
          border: Border.all(width: 1, color: Colors.white)),
      child: IconButton(
          onPressed: () async {
            _alarmTimeString = DateFormat('HH:mm').format(DateTime.now());
            await _showBottomSheet(context);
          },
          icon: Image.asset(
            'assets/add_alarm.png',
            height: 40,
            width: 40,
          )),
    );
  }

  _showBottomSheet(context) async {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 250,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      var selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        final now = DateTime.now();
                        var selectedDateTime = DateTime(now.year, now.month,
                            now.day, selectedTime.hour, selectedTime.minute);
                        _alarmTime = selectedDateTime;
                        setModalState(() {
                          _alarmTimeString =
                              DateFormat('HH:mm').format(selectedDateTime);
                        });
                      }
                    },
                    child: Text(
                      _alarmTimeString,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FloatingActionButton.extended(
                    onPressed: () {
                      Provider.of<ClockProvider>(context, listen: false)
                          .addAlarm(AlarmInfo(
                              title: 'Programming',
                              alarmDateTime: _alarmTime!,
                              isPending: true,
                              id: 1));
                      showNotification(
                          1, _alarmTime!.difference(DateTime.now()));
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.alarm),
                    label: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showNotification(alarmId, Duration duration) async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await widget.plugin.zonedSchedule(
        0,
        'Alarm',
        '',
        tz.TZDateTime.now(tz.local).add(duration),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name',
              channelDescription: 'your channel description',
              priority: Priority.high),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
