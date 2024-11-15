# 1.Music control

Music control, currently only for the Android platform, has two ways to achieve it:

1. Music control is implemented through the SDK internally

Rely on the NotificationListenerService of the Android platform, you need to enable the relevant permissions,
If the service is not running, there is no way to control music playback.

```dart
/// NotificationListenerService authorization example, requires plugin [flutter_notification_listener]
var hasPermission = await NotificationsListener.hasPermission;
if (!hasPermission!) {
    BleLog.d("no permission, so open settings");
    NotificationsListener.openPermissionSettings();
    return;
}
/// Is the NotificationListenerService running
var isRunning = await NotificationsListener.isRunning;

/// Make sure NotificationListenerService is running
/// Turn on Music Controls
BleConnector.getInstance.startMusicController();

/// Determine if the music control is running
BleConnector.getInstance.isMusicControllerRunning();

/// Stop music control
BleConnector.getInstance.stopMusicController();

```

2. Music control via API

```dart
/// The state of the play button can change the state of the device's play button, which requires the developer to synchronize the current music playback state to the device
BleConnector.getInstance.sendMusicPlayState(PlayState.PLAYING);
BleConnector.getInstance.sendMusicPlayState(PlayState.PAUSED);

/// The name of the song
BleConnector.getInstance.sendMusicTitle("aaa");

/// Mobile phone volume, 0-100
BleConnector.getInstance.sendPhoneVolume(50);

/// Triggered when the device media button is manipulated
void onReceiveMusicCommand(int musicCommand) {}

```

PlayState
PLAYING: Play
PAUSED: Paused

MusicCommand
int PLAY = 0x00;
int PAUSE = 0x01;
int TOGGLE = 0x02;
int NEXT = 0x03;
int PRE = 0x04;
int VOLUME_UP = 0x05;
int VOLUME_DOWN = 0x06;
int UNKNOWN = -1;

illustrate：
When the play button of most devices is clicked, [MusicCommand.TOGGLE] is returned, which is similar to [KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE].
The play button will not change state automatically. App needs to call [BleConnector.getInstance.sendMusicPlayState] to change the state of the device play button according to the current music playback state.