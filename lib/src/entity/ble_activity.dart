import 'package:sma_coding_dev_flutter_sdk/src/entity/ble_base.dart';

import '../common.dart';

class BleActivity extends BleBase<BleActivity> {
  int mTime = 0; //距离当地2000/1/1 00:00:00的秒数
  int mMode = 0; //运动模式，可参考下方 companion object 中的定义
  int mState = 0; //运动状态，可参考下方 companion object 中的定义
  int mStep = 0; //步数，例如值为10，即代表走了10步
  int mCalorie = 0; // 1/10000千卡，例如接收到的数据为56045，则代表 5.6045 Kcal 约等于 5.6 Kcal
  int mDistance = 0; // 1/10000米，例如接收到的数据为56045，则代表移动距离 5.6045 米 约等于 5.6 米
  int mActualTime = 0; //mTime转成实际的毫秒时间
  String mLocalTime = ""; //mTime转成实际的目期

  //运动模式 以下三种为自动识别的模式，没有开始、暂停、结束等状态
  static const int AUTO_NONE = 1;
  static const int AUTO_WALK = 2;
  static const int AUTO_RUN = 3;

  //运动模式 以下为手动锻炼模式 对应 mMode
  static const int RUNNING = 7; // 跑步
  static const int INDOOR = 8; // 室内运动，跑步机
  static const int OUTDOOR = 9; // 户外运动
  static const int CYCLING = 10; // 骑行
  static const int SWIMMING = 11; // 游泳
  static const int WALKING = 12; // 步行，健走
  static const int CLIMBING = 13; // 爬山
  static const int YOGA = 14; // 瑜伽
  static const int SPINNING = 15; // 动感单车
  static const int BASKETBALL = 16; // 篮球
  static const int FOOTBALL = 17; // 足球
  static const int BADMINTON = 18; // 羽毛球
  static const int MARATHON = 19; // 马拉松
  static const int INDOOR_WALKING = 20; // 室内步行
  static const int FREE_EXERCISE = 21; // 自由锻炼
  static const int AEROBIC_EXERCISE = 22; // 有氧运动
  static const int WEIGHTTRANNING = 23; // 力量训练
  static const int WEIGHTLIFTING = 24; // 举重
  static const int BOXING = 25; // 拳击
  static const int JUMP_ROPE = 26; // 跳绳
  static const int CLIMB_STAIRS = 27; // 爬楼梯
  static const int SKI = 28; // 滑雪
  static const int SKATE = 29; // 滑冰
  static const int ROLLER_SKATING = 30; // 轮滑
  static const int HULA_HOOP = 32; // 呼啦圈
  static const int GOLF = 33; // 高尔夫
  static const int BASEBALL = 34; // 棒球
  static const int DANCE = 35; // 舞蹈
  static const int PING_PONG = 36; // 乒乓球
  static const int HOCKEY = 37; // 曲棍球
  static const int PILATES = 38; // 普拉提
  static const int TAEKWONDO = 39; // 跆拳道
  static const int HANDBALL = 40; // 手球
  static const int DANCE_STREET = 41; // 街舞
  static const int VOLLEYBALL = 42; // 排球
  static const int TENNIS = 43; // 网球
  static const int DARTS = 44; // 飞镖
  static const int GYMNASTICS = 45; // 体操
  static const int STEPPING = 46; // 踏步
  static const int ELLIPIICAL = 47; //椭圆机
  static const int ZUMBA = 48; //尊巴
  static const int CRICHKET = 49; // 板球
  static const int TREKKING = 50; // 徒步旅行
  static const int AEROBICS = 51; // 有氧运动
  static const int ROWING_MACHINE = 52; // 划船机
  static const int RUGBY = 53; // 橄榄球
  static const int SIT_UP = 54; // 仰卧起坐
  static const int DUM_BLE = 55; // 哑铃
  static const int BODY_EXERCISE = 56; // 健身操
  static const int KARATE = 57; // 空手道
  static const int FENCING = 58; // 击剑
  static const int MARTIAL_ARTS = 59; // 武术
  static const int TAI_CHI = 60; // 太极拳
  static const int FRISBEE = 61; // 飞盘
  static const int ARCHERY = 62; // 射箭
  static const int HORSE_RIDING = 63; // 骑马
  static const int BOWLING = 64; // 保龄球
  static const int SURF = 65; // 冲浪
  static const int SOFTBALL = 66; // 垒球
  static const int SQUASH = 67; // 壁球
  static const int SAILBOAT = 68; // 帆船
  static const int PULL_UP = 69; // 引体向上
  static const int SKATEBOARD = 70; // 滑板
  static const int TRAMPOLINE = 71; // 蹦床
  static const int FISHING = 72; // 钓鱼
  static const int POLE_DANCING = 73; // 钢管舞
  static const int SQUARE_DANCE = 74; // 广场舞
  static const int JAZZ_DANCE = 75; // 爵士舞
  static const int BALLET = 76; // 芭蕾舞
  static const int DISCO = 77; // 迪斯科
  static const int TAP_DANCE = 78; // 踢踏舞
  static const int MODERN_DANCE = 79; // 现代舞
  static const int PUSH_UPS = 80; // 俯卧撑
  static const int SCOOTER = 81; // 滑板车
  static const int PLANK = 82; // 平板支撑
  static const int BILLIARDS = 83; // 桌球
  static const int ROCK_CLIMBING = 84;
  static const int DISCUS = 85; // 铁饼
  static const int RACE_RIDING = 86; // 赛马
  static const int WRESTLING = 87; // 摔跤
  static const int HIGH_JUMP = 88; // 跳高
  static const int PARACHUTE = 89; // 跳伞
  static const int SHOT_PUT = 90; // 铅球
  static const int LONG_JUMP = 91; // 跳远
  static const int JAVELIN = 92; // 标枪
  static const int HAMMER = 93; // 链球
  static const int SQUAT = 94; // 深蹲
  static const int LEG_PRESS = 95; // 压腿
  static const int OFF_ROAD_BIKE = 96; // 越野自行车
  static const int MOTOCROSS = 97; // 越野摩托车
  static const int ROWING = 98; // 赛艇
  static const int CROSSFIT = 99; // CROSSFIT
  static const int WATER_BIKE = 100; // 水上自行车
  static const int KAYAK = 101; // 皮划艇
  static const int CROQUET = 102; // 槌球
  static const int FLOOR_BALL = 103; // 地板球
  static const int THAI = 104; // 泰拳
  static const int JAI_BALL = 105; // 回力球
  static const int TENNIS_DOUBLES = 106; // 网球(双打)
  static const int BACK_TRAINING = 107; // 背部训练
  static const int WATER_VOLLEYBALL = 108; // 水上排球
  static const int WATER_SKIING = 109; // 滑水
  static const int MOUNTAIN_CLIMBER = 110; // 登山机
  static const int HIIT = 111; // HIIT  高强度间歇性训练
  static const int BODY_COMBAT = 112; // BODY COMBAT 搏击（拳击）的一种
  static const int BODY_BALANCE = 113; // BODY BALANCE  瑜伽、太极和普拉提融合在一起的身心训练项目
  static const int TRX = 114; // TRX 全身抗阻力锻炼 全身抗阻力锻炼
  static const int TAE_BO = 115; // 跆搏（TAE BO）   集跆拳道、空手道、拳击、自由搏击、舞蹈韵律操为一体

  //运动状态 手动锻炼模式下的状态 对应 mState
  static const int BEGIN = 0; // 开始
  static const int ONGOING = 1; // 进行中
  static const int PAUSE = 2; // 暂停
  static const int RESUME = 3; // 继续
  static const int END = 4; // 结束

  BleActivity();

  @override
  String toString() {
    return "BleActivity(mTime=$mTime, mMode=$mMode, mState=$mState, mStep=$mStep, mCalorie=$mCalorie, mDistance=$mDistance, mActualTime=$mActualTime, mLocalTime=$mLocalTime)";
  }

  factory BleActivity.fromJson(Map map) {
    BleActivity activity = BleActivity();
    activity.mTime = map["mTime"];
    activity.mMode = map["mMode"];
    activity.mState = map["mState"];
    activity.mStep = map["mStep"];
    activity.mCalorie = map["mCalorie"];
    activity.mDistance = map["mDistance"];
    activity.mActualTime = toTimeMillis(activity.mTime);
    activity.mLocalTime = DateTime.fromMillisecondsSinceEpoch(activity.mActualTime).toString();
    return activity;
  }

  static List<BleActivity> jsonToList(Map map) {
    List<BleActivity> list = [];
    List tmp = map["list"];
    for (map in tmp) {
      list.add(BleActivity.fromJson(map));
    }
    return list;
  }

  @override
  Map toJson() {
    Map map = {};
    map["mTime"] = mTime;
    map["mMode"] = mMode;
    map["mState"] = mState;
    map["mStep"] = mStep;
    map["mCalorie"] = mCalorie;
    map["mDistance"] = mDistance;
    map["mActualTime"] = mActualTime;
    map["mLocalTime"] = mLocalTime;
    return map;
  }
}
