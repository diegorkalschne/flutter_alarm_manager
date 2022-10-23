import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/snackbar_service.dart';
import 'views/alarm_view.dart';

void main() => runApp(const AlarmManagerApp());

class AlarmManagerApp extends StatelessWidget {
  const AlarmManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlarmManager Flutter',
      theme: ThemeData.dark(),
      home: const AlarmView(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('pt', 'BR')],
      navigatorKey: SnackbarService.navigatorKey,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
  }
}
