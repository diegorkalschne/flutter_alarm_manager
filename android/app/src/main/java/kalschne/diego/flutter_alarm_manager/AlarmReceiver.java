package kalschne.diego.flutter_alarm_manager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.Build;
import android.provider.Settings;

public class AlarmReceiver extends BroadcastReceiver {
    private MediaPlayer player;

    @Override
    public void onReceive(Context context, Intent intent) {
        player = MediaPlayer.create(context, Settings.System.DEFAULT_RINGTONE_URI);
        player.setLooping(false);
        player.start();

        // A partir do Android 10, não é possível inicializar a tela do aplicativo diretamente
        // Para isso, exiba uma notificação e, através da notificação, inicie a Activity
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            Intent main = new Intent(context, MainActivity.class);
            main.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(main);
        }
    }
}
