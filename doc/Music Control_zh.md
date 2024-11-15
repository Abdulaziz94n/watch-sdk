# 1.音乐控制

音乐控制，目前只针对安卓平台，有两种实现方式:

1. 通过SDK内部实现音乐控制

依赖安卓平台的NotificationListenerService，需要开启相关的权限，
如果服务没有运行，则无法控制音乐播放。

```dart
/// NotificationListenerService授权示例，需要依赖插件[flutter_notification_listener]
var hasPermission = await NotificationsListener.hasPermission;
if (!hasPermission!) {
    BleLog.d("no permission, so open settings");
    NotificationsListener.openPermissionSettings();
    return;
}
/// NotificationListenerService是否运行
var isRunning = await NotificationsListener.isRunning;

/// 确保NotificationListenerService运行中
/// 开启音乐控制
BleConnector.getInstance.startMusicController();

/// 判断音乐控制是否运行
BleConnector.getInstance.isMusicControllerRunning();

/// 停止音乐控制
BleConnector.getInstance.stopMusicController();

```

2. 通过API实现音乐控制

```dart
/// 播放按钮的状态，可以改变设备播放按钮的状态，这个需要开发者把当前音乐播放状态同步到设备上
BleConnector.getInstance.sendMusicPlayState(PlayState.PLAYING);
BleConnector.getInstance.sendMusicPlayState(PlayState.PAUSED);

/// 歌曲名称
BleConnector.getInstance.sendMusicTitle("aaa");

/// 手机音量，0-100
BleConnector.getInstance.sendPhoneVolume(50);

/// 操作设备媒体按钮时触发
void onReceiveMusicCommand(int musicCommand) {}

```

PlayState
PLAYING: 播放
PAUSED: 暂停

MusicCommand
int PLAY = 0x00;
int PAUSE = 0x01;
int TOGGLE = 0x02;
int NEXT = 0x03;
int PRE = 0x04;
int VOLUME_UP = 0x05;
int VOLUME_DOWN = 0x06;
int UNKNOWN = -1;

说明：
大部分设备的播放按钮被点击时，返回的都是[MusicCommand.TOGGLE]，类似[KeyEvent.KEYCODE_MEDIA_PLAY_PAUSE]，
播放按钮不会自动改变状态，需要App根据当前音乐的播放状态来调用[BleConnector.getInstance.sendMusicPlayState]改变设备播放按钮的状态。