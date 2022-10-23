package kalschne.diego.flutter_alarm_manager;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;

import java.util.Calendar;

public class AlarmController {
    private AlarmManager alarmManager;
    private Context context;

    public AlarmController(Context context) {
        this.context = context;
        alarmManager = (AlarmManager) this.context.getSystemService(Context.ALARM_SERVICE);
    }

    public void createAlarm(Calendar time) {
        Intent intent = new Intent(this.context, AlarmReceiver.class);

        // Ao criar um PendingIntent, se quiser futuramente poder distinguir um alarme entre vários criados, mantenha a geração do "requestCode"
        // de forma dinâmica (é ele que identifica um PendingIntent de forma única)
        PendingIntent alarmIntent = PendingIntent.getBroadcast(this.context, 0, intent, PendingIntent.FLAG_IMMUTABLE);

        // A partir da API 19, há mudanças na forma forma de se criar alarmes
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // Permite a execução do PendingIntent mesmo com o "Modo Soneca" habilitado
                alarmManager.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, time.getTimeInMillis(), alarmIntent);
            } else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, time.getTimeInMillis(), alarmIntent);
            }
        } else {
            // API 19 e inferiores
            alarmManager.set(AlarmManager.RTC_WAKEUP, time.getTimeInMillis(), alarmIntent);
        }

        registerRebootReceiver();
    }

    public void cancelAlarm(PendingIntent pendingIntent) {
        alarmManager.cancel(pendingIntent);
    }

    private void registerRebootReceiver() {
        ComponentName receiver = new ComponentName(context, RebootReceiver.class);
        PackageManager pm = context.getPackageManager();

        pm.setComponentEnabledSetting(receiver,
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                PackageManager.DONT_KILL_APP);
    }
}
