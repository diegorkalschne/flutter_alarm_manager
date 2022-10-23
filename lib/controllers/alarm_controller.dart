import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/snackbar_service.dart';
import '../utils/functions_utils.dart';

class AlarmController {
  static Future<void> createAlarm(TimeOfDay time) async {
    if (Platform.isAndroid) {
      // Converte o TimeOfDay para DateTime
      DateTime alarm = timeOfDayToDateTime(time);

      // Declaração do MethodChannel
      const platform =
          MethodChannel('br.com.diego.flutter_alarm_manager/alarmManager');

      // Formata a data obtida para o formato MM-dd-yyyy HH:mm
      String date = formatUSDate(alarm);

      // Chama o MethodChannel, no método 'createAlarm'
      bool success =
          await platform.invokeMethod<bool>('createAlarm', date) ?? false;

      // Calcula e exibe um SnackBar com o tempo restante para o alarme acionar
      if (success) {
        calculateRemainingTime(time, showSnack: true);
      } else {
        throw 'Failed';
      }
    } else {
      throw UnsupportedError('Unsupported platform ');
    }
  }

  static Future<void> cancelAlarm() async {
    const platform =
        MethodChannel('br.com.diego.flutter_alarm_manager/alarmManager');

    await platform.invokeMethod('cancelAlarm');
  }

  static Duration calculateRemainingTime(
    TimeOfDay time, {
    bool showSnack = false,
  }) {
    DateTime now = DateTime.now();

    DateTime alarm = timeOfDayToDateTime(time);

    Duration difference;

    difference = alarm.difference(now);

    difference = difference.abs();

    if (showSnack) {
      String hours = (difference.inHours % 24).toString().padLeft(2, '0');
      String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      String message = 'Alarme acionará em $hours horas e $minutes minutos';

      SnackbarService.showSnackbar(message: message);
    }

    return difference;
  }
}
