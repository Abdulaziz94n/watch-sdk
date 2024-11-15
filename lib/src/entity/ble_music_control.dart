class MusicCommand {
  static const int PLAY = 0x00;
  static const int PAUSE = 0x01;
  static const int TOGGLE = 0x02;
  static const int NEXT = 0x03;
  static const int PRE = 0x04;
  static const int VOLUME_UP = 0x05;
  static const int VOLUME_DOWN = 0x06;
  static const int UNKNOWN = -1;
}

class PlayState {
  static const int PAUSED = 0x00;
  static const int PLAYING = 0x01;
}
