class AlarmInfo {
  final int id;
  final String title;
  bool isPending;
  final DateTime alarmDateTime;

  AlarmInfo(
      {required this.title,
      required this.alarmDateTime,
      required this.id,
      required this.isPending});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'alarmDateTime': alarmDateTime.toString(),
      'isPending': isPending == true ? '1' : '0'
    };
  }

  factory AlarmInfo.fromMap(element) {
    return AlarmInfo(
        id: element['id'],
        title: element['title'],
        alarmDateTime: DateTime.parse(element['alarmDateTime']),
        isPending: element['isPending'] == '1' ? true : false);
  }
}
