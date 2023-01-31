import 'package:clock_app/helper/alarm_helper.dart';
import 'package:clock_app/model/alarm.dart';
import 'package:clock_app/model/enums.dart';
import 'package:flutter/foundation.dart';

class ClockProvider extends ChangeNotifier {
  ClockProvider() {
    _helper.getAlarms().then((value) {
      alarms = value;
      notifyListeners();
    });
  }
  final AlarmHelper _helper = AlarmHelper();
  MenuType menuType = MenuType.clock;
  List<AlarmInfo> alarms = [];
  changeMenu(menuType) {
    this.menuType = menuType;
    notifyListeners();
  }

  addAlarm(AlarmInfo alarm) {
    _helper.insertAlarm(alarm);
    alarms.add(alarm);
    notifyListeners();
  }

  deleteAlarm(AlarmInfo alarm) {
    _helper.delete(alarm.id);
    alarms.remove(alarm);
    notifyListeners();
  }

  updateAlarm(AlarmInfo alarm, value) {
    _helper.update(alarm.id, value);
    alarm.isPending = value;
    notifyListeners();
  }
}
