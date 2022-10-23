import 'package:flutter/material.dart';

import '../controllers/alarm_controller.dart';
import '../services/snackbar_service.dart';
import '../widgets/cs_elevated_button.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({Key? key}) : super(key: key);

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  TimeOfDay? _time;

  void _openTimerPicker() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (time != null) {
      _createAlarm(time);
    }
  }

  void _createAlarm(TimeOfDay time) async {
    try {
      await AlarmController.createAlarm(time);

      setState(() {
        _time = time;
      });
    } catch (_) {
      SnackbarService.showSnackbar(message: 'Erro ao criar alarme');
    }
  }

  void _cancelAlarm() async {
    try {
      await AlarmController.cancelAlarm();

      setState(() {
        _time = null;
      });

      SnackbarService.showSnackbar(message: 'Alarme cancelado');
    } catch (_) {
      SnackbarService.showSnackbar(message: 'Erro ao cancelar alarme');
    }
  }

  String _formatAlarmText() {
    return '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlarmManager'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CsElevatedButton(
              label: 'Set Alarm',
              onPressed: _openTimerPicker,
              backgroundColor: Colors.purple,
            ),
            if (_time != null) ...[
              //const SizedBox(height: 5),
              CsElevatedButton(
                label: 'Cancel Alarm',
                onPressed: _cancelAlarm,
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 5),
              Text(
                'Alarme definido às ${_formatAlarmText()}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
