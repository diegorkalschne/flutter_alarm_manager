package kalschne.diego.flutter_alarm_manager;

import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "br.com.diego.flutter_alarm_manager/alarmManager";

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("createAlarm")) {
                                String datetime = call.arguments();

                                boolean success = createAlarm(datetime);

                                result.success(success);
                            } else if (call.method.equals("cancelAlarm")) {
                                cancelAlarm();

                                result.success(null);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private boolean createAlarm(String date) {
        try {
            Calendar calendar = convertStringToCalendar(date);

            new AlarmController(getContext()).createAlarm(calendar);

            return true;
        } catch (Exception ex) {
            return false;
        }
    }

    private void cancelAlarm() {
        // Para cancelar um alarme, você deve recriar novamente uma PendindIntent, passando os mesmos parâmetros que foram passados no momento da criação do alarme
        // Em casos reais, baseie-se pelo "requestCode" para poder identificar um alarme de forma isolada
        Intent intent = new Intent(getContext(), AlarmReceiver.class);
        PendingIntent alarmIntent = PendingIntent.getBroadcast(getContext(), 0, intent, PendingIntent.FLAG_IMMUTABLE);

        new AlarmController(getContext()).cancelAlarm(alarmIntent);
    }

    private Calendar convertStringToCalendar(String date) throws ParseException {
        Calendar calendar = Calendar.getInstance();

        SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm");
        calendar.setTime(sdf.parse(date));

        return calendar;
    }
}
