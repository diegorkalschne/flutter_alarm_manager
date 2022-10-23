import 'package:flutter/material.dart';

/// Retorna a data no formato MM-dd-yyyy HH:mm
String formatUSDate(DateTime datetime) {
  String year = datetime.year.toString();
  String month = datetime.month.toString().padLeft(2, '0');
  String day = datetime.day.toString().padLeft(2, '0');
  String hour = datetime.hour.toString().padLeft(2, '0');
  String minute = datetime.minute.toString().padLeft(2, '0');

  return '$month-$day-$year $hour:$minute';
}

DateTime timeOfDayToDateTime(TimeOfDay time) {
  DateTime now = DateTime.now();

  DateTime alarm = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  if (now.isAfter(alarm)) {
    alarm = alarm.add(const Duration(days: 1));
  }

  return alarm;
}
