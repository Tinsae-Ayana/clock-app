import 'package:clock_app/model/alarm.dart';
import 'package:clock_app/provider/clock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlarmCard extends StatelessWidget {
  const AlarmCard(
      {Key? key,
      required this.plugin,
      required this.height,
      required this.width,
      required this.alarm})
      : super(key: key);
  final FlutterLocalNotificationsPlugin plugin;
  final double height;
  final double width;
  final AlarmInfo alarm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: height * 0.18,
      width: width * 0.60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.red]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.label,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(alarm.title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white))
                ],
              ),
              Switch(
                  activeColor: Colors.white,
                  value: alarm.isPending,
                  onChanged: (value) {
                    if (!value) plugin.cancel(1);
                    Provider.of<ClockProvider>(context, listen: false)
                        .updateAlarm(alarm, value);
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('HH:mm').format(alarm.alarmDateTime),
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 22),
              ),
              InkWell(
                onTap: () {
                  Provider.of<ClockProvider>(context, listen: false)
                      .deleteAlarm(alarm);
                },
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
