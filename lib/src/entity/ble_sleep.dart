import 'ble_base.dart';

class BleSleep extends BleBase<BleSleep> {
  static const int DEEP = 1; //深睡
  static const int LIGHT = 2; //浅睡
  static const int AWAKE = 3; //清醒
  static const int START = 17; //睡眠开始
  static const int END = 34; //睡眠结束-当前无有效定义和使用

  static const int ERROR_DATA = 14400; // 如果任意两条睡眠数据之间存在4小时的空白期,则判定此次睡眠数据无效

  int mTime = 0; // 距离当地2000/1/1 00:00:00的秒数
  int mMode = 0; // 睡眠状态
  int mSoft = 0; // 轻动，即睡眠过程中检测到相对轻微的动作
  int mStrong = 0; // 重动，即睡眠过程中检测到相对剧烈的运动

  BleSleep();

  ///[origin]设备返回当天的原始睡眠数据，数据必须是按时间升序排列的
  static List<BleSleep> analyseSleep(List<BleSleep> origin) {
    if (origin.length < 2) return [];

    //只保留最后（即最近）的一组睡眠数据
    int lastStartIndex = 0;
    origin.forEach((sleep) {
      if (sleep.mMode == START) {
        lastStartIndex = origin.indexOf(sleep);
      }
    });

    List<BleSleep> takeLastOrigin = [];
    origin.forEach((sleep) {
      if (origin.indexOf(sleep) >= lastStartIndex) {
        takeLastOrigin.add(sleep);
      }
    });

    //判断睡眠数据是否存在超过指定时间的间隔，超过此间隔代表睡眠失效
    for (int index = 0; index <= takeLastOrigin.length - 2; index++) {
      if ((takeLastOrigin[index + 1].mTime - takeLastOrigin[index].mTime) >=
          ERROR_DATA) {
        return [];
      }
    }

    List<BleSleep> result = [];
    takeLastOrigin.forEach((sleep) {
      switch (sleep.mMode) {
        case START:
          result.clear();
          break;
        case DEEP:
        case LIGHT:
        case AWAKE:
          result.add(sleep);
          break;
        case END:
          BleSleep tmp = BleSleep();
          tmp.mTime = sleep.mTime;
          tmp.mMode = result.last.mMode;
          tmp.mSoft = sleep.mSoft;
          tmp.mStrong = sleep.mStrong;
          result.add(tmp);
          break;
      }
    });

    return result;
  }

  ///获取各个状态的睡眠时长，单位分钟，[sleeps]必须是按时间升序排列的
  static Map<int, int> getSleepStatusDuration(List<BleSleep> sleeps) {
    Map<int, int> result = {LIGHT: 0, DEEP: 0, AWAKE: 0};
    for (int i = 0; i < sleeps.length - 1; i++) {
      BleSleep sleep = sleeps[i];
      int key = sleep.mMode;
      int duration = sleeps[i + 1].mTime - sleep.mTime;
      result[key] = result[key]! + duration;
    }
    result[LIGHT] = result[LIGHT]! ~/ 60;
    result[DEEP] = result[DEEP]! ~/ 60;
    result[AWAKE] = result[AWAKE]! ~/ 60;
    return result;
  }

  factory BleSleep.fromJson(Map map) {
    BleSleep sleep = BleSleep();
    sleep.mTime = map["mTime"];
    sleep.mMode = map["mMode"];
    sleep.mSoft = map["mSoft"];
    sleep.mStrong = map["mStrong"];
    return sleep;
  }

  static List<BleSleep> jsonToList(Map map) {
    List<BleSleep> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleSleep.fromJson(map));
    }
    return list;
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'BleSleep{mTime:$mTime, mMode:$mMode, mSoft:$mSoft, mStrong:$mStrong}';
  }
}
