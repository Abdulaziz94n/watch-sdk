import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:flutter/src/widgets/image.dart';
import 'package:image/image.dart' as img;

class WatchFacePage extends StatefulWidget {
  const WatchFacePage({Key? key}) : super(key: key);

  @override
  State<WatchFacePage> createState() => _WatchFacePageState();
}

class _WatchFacePageState extends State<WatchFacePage> with BleHandleCallback {
  String text = "Progress";

  String rootDir = "";

  /// 存储生成的背景图片, 预览图文件夹
  String rootDocumentsDir = "";

  String DIAL_CUSTOMIZE_DIR = "dial_customize_240";

  //digital_parameter
  String DIGITAL_AM_DIR = "am_pm";
  String DIGITAL_DATE_DIR = "date";
  String DIGITAL_HOUR_MINUTE_DIR = "hour_minute";
  String DIGITAL_WEEK_DIR = "week";

  //pointer_parameter
  String POINTER_HOUR = "pointer/hour";
  String POINTER_MINUTE = "pointer/minute";
  String POINTER_SECOND = "pointer/second";

  /// [BleDeviceInfo.mSupport2DAcceleration]
  /// 是否支持2d，支持2d的设备，生成的bin文件比较小，同步速度快。
  /// BleDeviceInfo.mSupport2DAcceleration == SUPPORT_2D_ACCELERATION_1 支持加速。
  var isSupport2DAcceleration = false;

  var ignoreBlack = 1; //是否忽略黑色，0-不忽略；1-忽略；4-杰里2D加速用

  var isPoint = false;

  int X_CENTER = BleWatchFaceElement.GRAVITY_X_CENTER_R;
  int Y_CENTER = BleWatchFaceElement.GRAVITY_Y_CENTER_R;

  int X_LEFT = BleWatchFaceElement.GRAVITY_X_LEFT;
  int Y_TOP = BleWatchFaceElement.GRAVITY_Y_TOP;

  //数字颜色
  var valueColor = 0;
  var digitalValueColor = 0;
  var pointerSelectNumber = 0;

  ///不同设备的分辨率和预览分辨率都不一样
  ///用户可以根据实际情况调整
  int screenWidth = 240;
  int screenHeight = 240;
  int previewWidth = 150;
  int previewHeight = 150;

  @override
  void onStreamProgress(bool status, int errorCode, int total, int completed) {
    setState(() {
      if (status) {
        text = "Progress:${(completed / total).toStringAsFixed(2)}";
        if (total == completed) {
          text = "done";
        }
      } else {
        text = "error:$errorCode";
      }
    });
  }

  var bgImgView = Image.asset("name");
  var pvImgView = Image.asset("name");

  @override
  void initState() {
    super.initState();
    BleConnector.getInstance.addHandleCallback(this);
    _unZip();
  }

  @override
  void dispose() {
    BleConnector.getInstance.removeHandleCallback(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WatchFace"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            bgImgView,
            pvImgView,
            ElevatedButton(onPressed: _startBtnClick, child: const Text("Star"))
          ],
        ),
      ),
    );
  }

  Future<void> _startBtnClick() async {

    //value
    String VALUE_DIR = "$DIAL_CUSTOMIZE_DIR/value";
    // control
    String CONTROL_DIR = "$DIAL_CUSTOMIZE_DIR/control";
    //time
    String TIME_DIR = "$DIAL_CUSTOMIZE_DIR/time";

    //digital
    String DIGITAL_DIR = "$TIME_DIR/digital";
    String POINTER_DIR = "$TIME_DIR/pointer";

    if(isSupport2DAcceleration) {
      ignoreBlack = 4;
    } else {
      ignoreBlack = 1;
    }

    // 这个是实际发送给设备的数据
    BleWatchFace watchFace = BleWatchFace();
    // 背景元素集合, 用于处理背景图片, 例如:和/符号, 步数, 卡路里等等图标
    List<BleWatchFaceElement> bgControls = [];

    //preview
    BleWatchFaceElement previewElement = BleWatchFaceElement();
    previewElement.type = BleWatchFaceElement.ELEMENT_PREVIEW;
    previewElement.hasAlpha = 0;//这个元素不需要alpha,减小体积
    previewElement.w = previewWidth;
    previewElement.h = previewHeight;
    previewElement.ignoreBlack = ignoreBlack;
    previewElement.imagePaths.add(
        "$rootDir/$DIAL_CUSTOMIZE_DIR/dial_bg_preview_file.png"); //示例图片，用户可以动态生成24位(rgb)png
    //watchFace.elementList.add(previewElement);

    //background
    BleWatchFaceElement backgroundElement = BleWatchFaceElement();
    backgroundElement.type = BleWatchFaceElement.ELEMENT_BACKGROUND;
    backgroundElement.hasAlpha = 0;//这个元素不需要alpha,减小体积
    backgroundElement.w = screenWidth;
    backgroundElement.h = screenHeight;
    backgroundElement.ignoreBlack = ignoreBlack;
    backgroundElement.imagePaths.add("$rootDir/$DIAL_CUSTOMIZE_DIR/dial_bg_file_3.png"); //示例图片，用户可以动态生成24位(rgb)png
    //watchFace.elementList.add(backgroundElement);

    //step
    BleWatchFaceElement stepElement = BleWatchFaceElement();
    stepElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_STEP;
    stepElement.hasAlpha = 1;
    stepElement.w = 10;
    stepElement.h = 14;
    stepElement.gravity = X_CENTER | Y_CENTER;
    stepElement.x = 121;
    stepElement.y = 71;
    stepElement.ignoreBlack = ignoreBlack;
    stepElement.imagePaths.addAll(getNumberPaths("$rootDir/$VALUE_DIR/$valueColor", 10));
    watchFace.elementList.add(stepElement);

    // step icon
    BleWatchFaceElement stepControl = BleWatchFaceElement();
    stepControl.type = BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND;
    stepControl.w = 38;
    stepControl.h = 38;
    stepControl.x = (screenWidth ~/ 2) - (stepControl.w ~/ 2);
    stepControl.y = 20;
    stepControl.imagePaths = ["$rootDir/$CONTROL_DIR/step/step_0.png"];
    bgControls.add(stepControl);
    // step preview number, 这个元素虽然添加到了watchFace.elementList里面, 在最后, 发指令时候, 会将这类元素去除, 这个仅仅是为了方便处理预览图
    BleWatchFaceElement stepNumberControl = BleWatchFaceElement();
    stepNumberControl.type = BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW;
    stepNumberControl.w = 40;
    stepNumberControl.h = 14;
    stepNumberControl.x = (screenWidth ~/ 2) - (stepControl.w ~/ 2);
    stepNumberControl.y = stepControl.h + 20;
    stepNumberControl.imagePaths = ["$rootDir/$CONTROL_DIR/step/step_0_number.png"];
    watchFace.elementList.add(stepNumberControl);


    //hr
    BleWatchFaceElement hrElement = BleWatchFaceElement();
    hrElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_HEART;
    hrElement.hasAlpha = 1;
    hrElement.w = 10;
    hrElement.h = 14;
    hrElement.gravity = X_CENTER | Y_CENTER;
    hrElement.x = 27;
    hrElement.y = 140;
    hrElement.ignoreBlack = ignoreBlack;
    hrElement.imagePaths.addAll(getNumberPaths("$rootDir/$VALUE_DIR/$valueColor", 10));
    watchFace.elementList.add(hrElement);

    // hr icon
    BleWatchFaceElement hrControl = BleWatchFaceElement();
    hrControl.type = BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND;
    hrControl.w = 38;
    hrControl.h = 38;
    hrControl.x = 10;
    hrControl.y = (screenHeight ~/ 2) - (hrControl.h ~/ 2);
    hrControl.imagePaths = ["$rootDir/$CONTROL_DIR/heart_rate/heart_rate_0.png"];
    bgControls.add(hrControl);
    // hr preview number, 这个元素虽然添加到了watchFace.elementList里面, 在最后, 发指令时候, 会将这类元素去除, 这个仅仅是为了方便处理预览图
    BleWatchFaceElement hrNumberControl = BleWatchFaceElement();
    hrNumberControl.type = BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW;
    hrNumberControl.w = 20;
    hrNumberControl.h = 14;
    hrNumberControl.x = 15;
    hrNumberControl.y = hrControl.y + hrControl.h + 5;
    hrNumberControl.imagePaths = ["$rootDir/$CONTROL_DIR/heart_rate/heart_rate_0_number.png"];
    watchFace.elementList.add(hrNumberControl);

    //calories
    BleWatchFaceElement calElement = BleWatchFaceElement();
    calElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_CALORIE;
    calElement.hasAlpha = 1;
    calElement.w = 10;
    calElement.h = 14;
    calElement.gravity = X_CENTER | Y_CENTER;
    calElement.x = 121;
    calElement.y = 226;
    calElement.ignoreBlack = ignoreBlack;
    calElement.imagePaths.addAll(getNumberPaths("$rootDir/$VALUE_DIR/$valueColor", 10));
    watchFace.elementList.add(calElement);

    // calories icon
    BleWatchFaceElement calControl = BleWatchFaceElement();
    calControl.type = BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND;
    calControl.w = 38;
    calControl.h = 38;
    calControl.x = screenWidth - 30 - calControl.w;
    calControl.y = (screenHeight ~/ 2) - (calControl.h ~/ 2) - 10;
    calControl.imagePaths = ["$rootDir/$CONTROL_DIR/calories/calories_0.png"];
    bgControls.add(calControl);
    // calories preview number, 这个元素虽然添加到了watchFace.elementList里面, 在最后, 发指令时候, 会将这类元素去除, 这个仅仅是为了方便处理预览图
    BleWatchFaceElement caloriesNumberControl = BleWatchFaceElement();
    caloriesNumberControl.type = BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW;
    caloriesNumberControl.w = 40;
    caloriesNumberControl.h = 14;
    caloriesNumberControl.x = screenWidth - 30 - calControl.w;
    caloriesNumberControl.y = calControl.y + calControl.h + 5;
    caloriesNumberControl.imagePaths = ["$rootDir/$CONTROL_DIR/calories/calories_0_number.png"];
    watchFace.elementList.add(caloriesNumberControl);

    //distance
    BleWatchFaceElement disElement = BleWatchFaceElement();
    disElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_DISTANCE;
    disElement.hasAlpha = 1;
    disElement.w = 10;
    disElement.h = 14;
    disElement.gravity = X_CENTER | Y_CENTER;
    disElement.x = 190;
    disElement.y = 140;
    disElement.ignoreBlack = ignoreBlack;
    disElement.imagePaths.addAll(getNumberPaths("$rootDir/$VALUE_DIR/$valueColor", 10));
    watchFace.elementList.add(disElement);

    // distance icon
    BleWatchFaceElement disControl = BleWatchFaceElement();
    disControl.type = BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND;
    disControl.w = 38;
    disControl.h = 38;
    disControl.x = (screenWidth ~/ 2) - (disControl.w ~/ 2);
    disControl.y = (screenHeight - 30) - disControl.h;
    disControl.imagePaths = ["$rootDir/$CONTROL_DIR/distance/distance_0.png"];
    bgControls.add(disControl);
    // calories preview number, 这个元素虽然添加到了watchFace.elementList里面, 在最后, 发指令时候, 会将这类元素去除, 这个仅仅是为了方便处理预览图
    BleWatchFaceElement disNumberControl = BleWatchFaceElement();
    disNumberControl.type = BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW;
    disNumberControl.w = 40;
    disNumberControl.h = 14;
    disNumberControl.x = (screenWidth ~/ 2) - (disControl.w ~/ 2);
    disNumberControl.y = screenHeight - disNumberControl.h - 8;
    disNumberControl.imagePaths = ["$rootDir/$CONTROL_DIR/distance/distance_0_number.png"];
    watchFace.elementList.add(disNumberControl);

    if (isPoint) {
      watchFace.elementList.add(getPointerElement(
          BleWatchFaceElement.ELEMENT_NEEDLE_HOUR,
          "$rootDir/$POINTER_DIR/$POINTER_HOUR/$pointerSelectNumber.png",
          12,
          240));
      watchFace.elementList.add(getPointerElement(
          BleWatchFaceElement.ELEMENT_NEEDLE_MIN,
          "$rootDir/$POINTER_DIR/$POINTER_MINUTE/$pointerSelectNumber.png",
          12,
          240));
      watchFace.elementList.add(getPointerElement(
          BleWatchFaceElement.ELEMENT_NEEDLE_SEC,
          "$rootDir/$POINTER_DIR/$POINTER_SECOND/$pointerSelectNumber.png",
          10,
          240));
    } else {
      //ampm
      BleWatchFaceElement ampmElement = BleWatchFaceElement();
      ampmElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_AMPM;
      ampmElement.hasAlpha = 1;
      ampmElement.w = 34;
      ampmElement.h = 20;
      ampmElement.gravity = X_LEFT | Y_TOP;
      ampmElement.x = 140;
      ampmElement.y = 78;
      ampmElement.ignoreBlack = ignoreBlack;
      ampmElement.imagePaths.add("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_AM_DIR/am.png");
      ampmElement.imagePaths.add("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_AM_DIR/pm.png");
      watchFace.elementList.add(ampmElement);

      //time-hour
      BleWatchFaceElement hourElement = BleWatchFaceElement();
      hourElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_HOUR;
      hourElement.hasAlpha = 1;
      hourElement.w = 26;
      hourElement.h = 42;
      hourElement.gravity = X_LEFT | Y_TOP;
      hourElement.x = 60;
      hourElement.y = 104;
      hourElement.ignoreBlack = ignoreBlack;
      hourElement.imagePaths.addAll(getNumberPaths("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_HOUR_MINUTE_DIR", 9));
      watchFace.elementList.add(hourElement);

      // timeSymbol Element
      BleWatchFaceElement timeSymbolElement = BleWatchFaceElement();
      timeSymbolElement.type = BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND;
      timeSymbolElement.w = 16;
      timeSymbolElement.h = 42;
      timeSymbolElement.x = hourElement.x + (hourElement.w * 2);
      timeSymbolElement.y = hourElement.y;
      timeSymbolElement.imagePaths.add("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_HOUR_MINUTE_DIR/symbol.png");
      watchFace.elementList.add(timeSymbolElement);

      //time-minute
      BleWatchFaceElement minuteElement = BleWatchFaceElement();
      minuteElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_MIN;
      minuteElement.hasAlpha = 1;
      minuteElement.w = 26;
      minuteElement.h = 42;
      minuteElement.gravity = X_LEFT | Y_TOP;
      minuteElement.x = 128;
      minuteElement.y = 104;
      minuteElement.ignoreBlack = ignoreBlack;
      minuteElement.imagePaths.addAll(getNumberPaths("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_HOUR_MINUTE_DIR", 9));
      watchFace.elementList.add(minuteElement);

      //date-month
      BleWatchFaceElement monthElement = BleWatchFaceElement();
      monthElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_MONTH;
      monthElement.hasAlpha = 1;
      monthElement.w = 12;
      monthElement.h = 20;
      monthElement.gravity = X_LEFT | Y_TOP;
      monthElement.x = 60;
      monthElement.y = 152;
      monthElement.ignoreBlack = ignoreBlack;
      monthElement.imagePaths.addAll(getNumberPaths("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_DATE_DIR", 9));
      watchFace.elementList.add(monthElement);

      // dateSymbol Element
      BleWatchFaceElement dateSymbolElement = BleWatchFaceElement();
      dateSymbolElement.type = BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND;
      dateSymbolElement.w = 12;
      dateSymbolElement.h = 20;
      dateSymbolElement.x = monthElement.x + (monthElement.w * 2);
      dateSymbolElement.y = monthElement.y;
      dateSymbolElement.imagePaths.add("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_DATE_DIR/symbol.png");
      watchFace.elementList.add(dateSymbolElement);

      //date-day
      BleWatchFaceElement dayElement = BleWatchFaceElement();
      dayElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_DAY;
      dayElement.hasAlpha = 1;
      dayElement.w = 12;
      dayElement.h = 20;
      dayElement.gravity = X_LEFT | Y_TOP;
      dayElement.x = 96;
      dayElement.y = 152;
      dayElement.ignoreBlack = ignoreBlack;
      dayElement.imagePaths.addAll(getNumberPaths("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_DATE_DIR", 9));
      watchFace.elementList.add(dayElement);

      //date-week
      BleWatchFaceElement weekElement = BleWatchFaceElement();
      weekElement.type = BleWatchFaceElement.ELEMENT_DIGITAL_WEEKDAY;
      weekElement.hasAlpha = 1;
      weekElement.w = 48;
      weekElement.h = 20;
      weekElement.gravity = X_LEFT | Y_TOP;
      weekElement.x = 126;
      weekElement.y = 152;
      weekElement.ignoreBlack = ignoreBlack;
      weekElement.imagePaths.addAll(getNumberPaths("$rootDir/$DIGITAL_DIR/$digitalValueColor/$DIGITAL_WEEK_DIR", 6));
      watchFace.elementList.add(weekElement);

      // 添加到数组
      bgControls.add(timeSymbolElement);
      bgControls.add(dateSymbolElement);
    }


    // 处理背景图片
    var bgImage = img.decodePng(File(backgroundElement.imagePaths.first).readAsBytesSync());
    for (var i = 0; i < bgControls.length; i++) {
      var eleModel = bgControls[i];
      if (eleModel.type == BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW) {
        // 预览图元素是绘制在预览图上的, 这里不要不用处理
      } else {
        final symControl =
        img.decodePng(File(eleModel.imagePaths.first).readAsBytesSync());
        img.compositeImage(bgImage!, symControl!, dstX: eleModel.x, dstY: eleModel.y);
      }
    }

    // 存储背景图到本地
    var watchFaceBg = img.copyCropCircle(bgImage!);
    final bgFile = File("$rootDocumentsDir/watch_face_bg.png");
    bgFile.writeAsBytesSync(img.encodePng(watchFaceBg));

    // 重要的赋值, 重新赋值背景图片路径
    backgroundElement.imagePaths = [bgFile.path];
    watchFace.elementList.insert(0, backgroundElement);

    // 将背景图片展示给用户看
    var tempBgImg = img.copyCropCircle(img.decodePng(bgFile.readAsBytesSync())!);
    setState(() {
      // 获得Flutter 显示的Image对象, 显示到页面
      bgImgView = Image.memory(img.encodePng(tempBgImg));
    });



    // 处理预览图, 添加拼接元素, 获取到元素的x, y以及图片路径方便后续处理
    var previewPath = "";
    List<BleControlModel> pvSubCtrls = [];
    for (var i = 0; i < watchFace.elementList.length; i++) {
      var elementModel = watchFace.elementList[i];
      if (elementModel.type == BleWatchFaceElement.ELEMENT_DIGITAL_AMPM || elementModel.type == BleWatchFaceElement.ELEMENT_DIGITAL_WEEKDAY) {
        var amCtrl = BleControlModel();
        amCtrl.x = elementModel.x;
        amCtrl.y = elementModel.y;
        amCtrl.imagePath = elementModel.imagePaths.first;

        pvSubCtrls.add(amCtrl);
      } else if (elementModel.type == BleWatchFaceElement.ELEMENT_DIGITAL_HOUR) {
        // 小时, 需要准备2个
        // 小时, 十位图片数字0
        var zeroImgPath = elementModel.imagePaths.first;
        var hourZeroCtrl = BleControlModel();
        hourZeroCtrl.x = elementModel.x;
        hourZeroCtrl.y = elementModel.y;
        hourZeroCtrl.imagePath = zeroImgPath;

        pvSubCtrls.add(hourZeroCtrl);

        // 小时, 个位图片数字8
        if (elementModel.imagePaths.length > 8) {
          var eightImgPath = elementModel.imagePaths[8];
          var hourEightCtrl = BleControlModel();
          hourEightCtrl.x = elementModel.x + elementModel.w;
          hourEightCtrl.y = elementModel.y;
          hourEightCtrl.imagePath = eightImgPath;

          pvSubCtrls.add(hourEightCtrl);
        }
      } else if (elementModel.type == BleWatchFaceElement.ELEMENT_DIGITAL_MIN) {
        // 分钟, 需要准备2个
        // 分钟, 十位图片数字3
        if (elementModel.imagePaths.length > 3) {
          var threeImgPath = elementModel.imagePaths[3];
          var minuteThreeCtrl = BleControlModel();
          minuteThreeCtrl.x = elementModel.x;
          minuteThreeCtrl.y = elementModel.y;
          minuteThreeCtrl.imagePath = threeImgPath;

          pvSubCtrls.add(minuteThreeCtrl);
        }

        if (elementModel.imagePaths.isNotEmpty) {
          var zeroImgPath = elementModel.imagePaths[0];
          var minuteZeroCtrl = BleControlModel();
          minuteZeroCtrl.x = elementModel.x + elementModel.w;
          minuteZeroCtrl.y = elementModel.y;
          minuteZeroCtrl.imagePath = zeroImgPath;

          pvSubCtrls.add(minuteZeroCtrl);
        }
      } else if (elementModel.type == BleWatchFaceElement.ELEMENT_DIGITAL_MONTH) {
        // 月份, 需要准备2个
        // 月份, 个位
        if (elementModel.imagePaths.length > 1) {
          var zeroImgPath = elementModel.imagePaths[1];
          var monthZeroCtrl = BleControlModel();
          monthZeroCtrl.x = elementModel.x;
          monthZeroCtrl.y = elementModel.y;
          monthZeroCtrl.imagePath = zeroImgPath;

          pvSubCtrls.add(monthZeroCtrl);
        }

        // 月份, 十位
        if (elementModel.imagePaths.length > 7) {
          var sevenImgPath = elementModel.imagePaths[7];
          var monthSevenCtrl = BleControlModel();
          monthSevenCtrl.x = elementModel.x + elementModel.w;
          monthSevenCtrl.y = elementModel.y;
          monthSevenCtrl.imagePath = sevenImgPath;

          pvSubCtrls.add(monthSevenCtrl);
        }
      } else if (elementModel.type == BleWatchFaceElement.ELEMENT_DIGITAL_DAY) {
        // 日期天, 需要准备2个
        // 日期天, 个位
        if (elementModel.imagePaths.length > 1) {
          var zeroImgPath = elementModel.imagePaths[1];
          var dayZeroCtrl = BleControlModel();
          dayZeroCtrl.x = elementModel.x;
          dayZeroCtrl.y = elementModel.y;
          dayZeroCtrl.imagePath = zeroImgPath;

          pvSubCtrls.add(dayZeroCtrl);
        }

        // 日期天, 十位
        if (elementModel.imagePaths.length > 8) {
          var eightImgPath = elementModel.imagePaths[8];
          var monthEightCtrl = BleControlModel();
          monthEightCtrl.x = elementModel.x + elementModel.w;
          monthEightCtrl.y = elementModel.y;
          monthEightCtrl.imagePath = eightImgPath;

          pvSubCtrls.add(monthEightCtrl);
        }
      } else if (elementModel.type == BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW) {

        var amCtrl = BleControlModel();
        amCtrl.x = elementModel.x;
        amCtrl.y = elementModel.y;
        amCtrl.imagePath = elementModel.imagePaths.first;

        pvSubCtrls.add(amCtrl);
      }
    }

    // 处理预览图, 拼接图片
    var watchFacePv = watchFaceBg;
    for (var i = 0; i < pvSubCtrls.length; i++) {
      var pvSubModel = pvSubCtrls[i];
      final pvSubControl = img.decodePng(File(pvSubModel.imagePath).readAsBytesSync());
      img.compositeImage(watchFacePv!, pvSubControl!, dstX: pvSubModel.x, dstY: pvSubModel.y);
    }

    // 处理指针类型的预览图, 指针比较特殊, 需要缩放一下图片, 这个图片是需要结合设计的切图做调整x, y, w, h等参数
    // Processing pointer type preview images. Pointers are special and need to be scaled. This image needs to be adjusted in conjunction with the cut image of the design, such as x, y, w, h and other parameters.
    if (isPoint) {

      var pointX = (screenWidth - previewWidth) ~/ 2;
      var pointY = (screenHeight - previewHeight) ~/ 2;
      final pointPv = img.decodePng(File("$rootDir/$POINTER_DIR/preview/pointer_1.png").readAsBytesSync());
      var pointPvImg = img.copyResize(pointPv!, width: previewWidth, height: previewHeight);

      img.compositeImage(watchFacePv!, pointPvImg!, dstX: pointX, dstY: pointY);
    }

    watchFacePv = img.copyResize(watchFacePv, width: previewWidth, height: previewHeight);
    final pvFile = File("$rootDocumentsDir/watch_face_pv.png");
    pvFile.writeAsBytesSync(img.encodePng(watchFacePv));


    // 重要的赋值, 重新赋值预览图路径
    previewPath = pvFile.path;
    previewElement.imagePaths = [previewPath];
    watchFace.elementList.insert(0, previewElement);

    // 将预览图, 展示到页面查看
    var tempPvImg = img.copyCropCircle(img.decodePng(File(previewPath).readAsBytesSync())!);
    setState(() {
      // 获得Flutter 显示的Image对象, 显示到页面
      pvImgView = Image.memory(img.encodePng(tempPvImg));
    });


    // 去除不相关的元素 Remove irrelevant elements
    // 下面这2类元素主要是为了Flutter处理图片而已, 其他不做处理, 对于表盘元素来说完全用不到, 所以移除
    // The following two types of elements are mainly used for Flutter to process images. Others are not processed. They are completely unused for dial elements, so they are removed.
    //  背景控件元素, Background control element
    // static const int ELEMENT_BG_CONTROL = 0x16;
    //  Time, date symbol control type
    // static const int ELEMENT_BG_CONTROL_SYMBOL = 0x17;
    for (var i = 0; i < watchFace.elementList.length; i++) {
      var elementModel = watchFace.elementList[i];
      if (elementModel.type == BleWatchFaceElement.ELEMENT_CONTROL_BACKGROUND || elementModel.type == BleWatchFaceElement.ELEMENT_CONTROL_PREVIEW) {
        watchFace.elementList.removeAt(i);
      }
    }

    // 发送表盘数据到设备
    BleConnector.getInstance.sendObject(BleKey.WATCH_FACE, BleKeyFlag.UPDATE, watchFace);
  }

  List<String> getNumberPaths(String dir, int range) {
    List<String> paths = [];
    for (int i = 0; i <= range; i++) {
      paths.add("$dir/$i.png");
    }
    return paths;
  }

  BleWatchFaceElement getPointerElement(int type, String path, int w, int h) {
    //设备内存有限，时针、分针、秒钟总大小不能太大，不然显示不了。
    //示例图片的指针有很多透明的地方，透明的地方也是很占容量的，实际传入有效的高度即可，sdk内部会根据h自动截取。
    //bottomOffset, leftOffset也要相应调整。
    int tmpH = (h * 0.6).toInt();
    BleWatchFaceElement element = BleWatchFaceElement();
    element.type = type;
    element.hasAlpha = 1;
    element.w = w;
    element.h = tmpH;//根据实际情况调整
    element.gravity = X_LEFT | Y_TOP;
    element.x = screenWidth ~/ 2;
    element.y = screenHeight ~/ 2;
    element.bottomOffset = tmpH - h ~/ 2;//根据实际情况调整
    element.leftOffset = w ~/ 2;//根据实际情况调整
    element.ignoreBlack = 1;//指针不压缩，设为1
    element.imagePaths.add(path);
    return element;
  }

  ///解压表盘示例资源
  void _unZip() async {
    rootDir = "${(await getApplicationDocumentsDirectory()).path}/custom";
    BleLog.d("rootDir -> $rootDir");
    List<int> bytes = (await rootBundle.load("assets/custom.zip")).buffer.asInt8List();
    Archive archive = ZipDecoder().decodeBytes(bytes);
    for (ArchiveFile file in archive) {
      if (file.isFile) {
        List<int> data = file.content;
        File("$rootDir/${file.name}")
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory("$rootDir/${file.name}")
            .create(recursive: true);
      }
    }

    // 存储表盘背景, 预览图的文件夹
    rootDocumentsDir =
        "${(await getApplicationDocumentsDirectory()).path}/bg_pv";
    var tempFile = File(rootDocumentsDir);
    if (!await tempFile.exists()) {
      // 文件夹不存在, 创建一个
      Directory(rootDocumentsDir).create(recursive: true);
    }


    setState(() {
      bgImgView = Image.file(File("$rootDir/$DIAL_CUSTOMIZE_DIR/dial_bg_file_3.png"));
      pvImgView = Image.file(File("$rootDir/$DIAL_CUSTOMIZE_DIR/dial_bg_preview_file.png"));
    });
  }
}

class BleControlModel {
  var type = 0;
  var x = 0;
  var y = 0;
  /// 角度, 仅指针元素才会用的到
  var angle = 0;
  var imagePath = "";

  @override
  String toString() {
    return "ABHControlModel(type=$type, x=$x, y:$y, imagePath:$imagePath)";
  }
}
