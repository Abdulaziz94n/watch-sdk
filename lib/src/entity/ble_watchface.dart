import 'ble_base.dart';

class BleWatchFaceElement extends BleBase<BleWatchFaceElement> {

  /// [gravity]
  static const GRAVITY_X_LEFT = 1;
  static const GRAVITY_X_RIGHT = 1 << 1;
  static const GRAVITY_X_CENTER = 1 << 2;
  static const GRAVITY_Y_TOP = 1 << 3;
  static const int GRAVITY_Y_BOTTOM = 1 << 4;
  static const int GRAVITY_Y_CENTER = 1 << 5;

  static const int GRAVITY_X_CENTER_R = 1 << 1;
  static const int GRAVITY_X_RIGHT_R = 1 << 2;
  static const int GRAVITY_Y_CENTER_R = 1 << 4;
  static const int GRAVITY_Y_BOTTOM_R = 1 << 5;

  /// [type]
  static const int ELEMENT_PREVIEW = 0x01;
  static const int ELEMENT_BACKGROUND = 0x02;     //背景无法移动,且默认全屏,设置坐标无意义
  static const int ELEMENT_NEEDLE_HOUR = 0x03;
  static const int ELEMENT_NEEDLE_MIN = 0x04;
  static const int ELEMENT_NEEDLE_SEC = 0x05;
  static const int ELEMENT_DIGITAL_YEAR = 0x06;
  static const int ELEMENT_DIGITAL_MONTH = 0x07;
  static const int ELEMENT_DIGITAL_DAY = 0x08;
  static const int ELEMENT_DIGITAL_HOUR = 0x09;
  static const int ELEMENT_DIGITAL_MIN = 0x0A;
  static const int ELEMENT_DIGITAL_SEC = 0x0B;
  static const int ELEMENT_DIGITAL_AMPM = 0x0C;
  static const int ELEMENT_DIGITAL_WEEKDAY = 0x0D;
  static const int ELEMENT_DIGITAL_STEP = 0x0E;
  static const int ELEMENT_DIGITAL_HEART = 0x0F;
  static const int ELEMENT_DIGITAL_CALORIE = 0x10;
  static const int ELEMENT_DIGITAL_DISTANCE = 0x11;
  static const int ELEMENT_DIGITAL_BAT = 0x12;
  static const int ELEMENT_DIGITAL_BT = 0x13;
  static const int ELEMENT_DIGITAL_DIV_HOUR = 0x14;
  static const int ELEMENT_DIGITAL_DIV_MONTH = 0x15;


  /// 绘制在背景图片上的符号元素, 例如:和/, 以及步数, 卡路里图标等等元素
  /// Symbol elements drawn on the background image, such as: and /, as well as steps, calories icons and other elements
  static const int ELEMENT_CONTROL_BACKGROUND = 0x16;
  /// 绘制在预览图片上的数字元素, 例如:步数显示的2069, 心率显示的90等等元素
  /// Numeric elements drawn on the preview image, such as: 2069 for step count display, 90 for heart rate display, etc.
  static const int ELEMENT_CONTROL_PREVIEW = 0x17;


  int type = 0; //元素类型
  int hasAlpha = 0; //图片是否包含alpha通道, 0-不带alpha；1-带alpha
  int w = 0;  //图片宽，必须是2的倍数
  int h = 0;  //图片高
  int gravity = 0; //对齐方式
  int ignoreBlack = 0;//是否忽略黑色，0-不忽略；1-忽略；4-杰里2D加速用
  int x = 0; //anchor确定坐标
  int y = 0; //anchor确定坐标
  int bottomOffset = 0; //指针类型的元素，底部到旋转中心点之间的偏移量
  int leftOffset = 0; //指针类型的元素，左部到旋转中心点之间的偏移量
  List<String> imagePaths = [];//图片路径，目前只支持png

  BleWatchFaceElement();

  @override
  String toString() {
    return "BleWatchFaceElement(type=$type, hasAlpha=$hasAlpha, w=$w, h=$h, gravity=$gravity, x=$x, y=$y, "
        "bottomOffset=$bottomOffset, leftOffset=$leftOffset, imagePaths=$imagePaths)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["type"] = type;
    map["hasAlpha"] = hasAlpha;
    map["w"] = w;
    map["h"] = h;
    map["gravity"] = gravity;
    map["ignoreBlack"] = ignoreBlack;
    map["x"] = x;
    map["y"] = y;
    map["bottomOffset"] = bottomOffset;
    map["leftOffset"] = leftOffset;
    map["imagePaths"] = imagePaths;
    return map;
  }
}

class BleWatchFace extends BleBase<BleWatchFace> {
  /// [imageFormat]
  static const PNG_ARGB_8888 = 0x01;
  static const BMP_565 = 0x02;

  int imageFormat = BMP_565;

  List<BleWatchFaceElement> elementList = [];

  BleWatchFace();

  @override
  String toString() {
    return "BleWatchFace(imageFormat=$imageFormat, elementList=$elementList)";
  }

  @override
  Map toJson() {
    Map map = {};
    map["imageFormat"] = imageFormat;
    map["elementList"] = elementList;
    return map;
  }
}
