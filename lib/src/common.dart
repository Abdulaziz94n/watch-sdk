import 'dart:collection';

import '../sma_coding_dev_flutter_sdk.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Type typeOf<T>() => T;

extension MapExtension on Map {
  List<T>? listValue<T>(String key) {
    if (containsKey(key)) {
      List obj = this[key];
      List<T> strList = [];
      for (var item in obj) {
        strList.add(item);
      }
      return strList;
    }
    return null;
  }
}

Map<String, dynamic> getReq(
    BleKey bleKey, BleKeyFlag bleKeyFlag, Object? value) {
  return {
    "bleKey": bleKey.toKey(),
    "bleKeyFlag": bleKeyFlag.toKey(),
    "value": value
  };
}

///将ble类里面的time转成实际的毫秒时间
int toTimeMillis(int time) {
  var offset = DateTime.now().timeZoneOffset.inMilliseconds;
  return (time + DATA_EPOCH) * 1000 - offset;
}

String _twoDigits(int n) {
if (n >= 10) return "$n";
return "0$n";
}

///返回日期, 默认yyyy-mm-dd
String getDateString(int time) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(time);
  return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}";
}

///将设备返回的BleActivity缓存起来
Future<void> cacheActivity(List<BleActivity> activities) async {
  String activityDir = "${(await getApplicationDocumentsDirectory()).path}/activity";
  //按天分组
  var groupData = <String, List<BleActivity>>{};
  for (var element in activities) {
    var key = getDateString(element.mActualTime);
    if (groupData[key] == null) {
      groupData[key] = [];
    }
    groupData[key]?.add(element);
  }
  for(var key in groupData.keys) {
    File file = File("$activityDir/$key");
    List<BleActivity> tmpList = [];
    List<BleActivity>? newList = groupData[key];
    //存在缓存则更新缓存
    if(await file.exists()) {
      List<dynamic> localList = json.decode(await file.readAsString());
      for (var local in localList) {
        tmpList.add(BleActivity.fromJson(local));
      }
      if (newList != null) {
        for (var obj in newList) {
          var has = false;
          for(var tmpObj in tmpList) {
            if(obj.mTime == tmpObj.mTime) {
              has = true;
              break;
            }
          }
          if(!has) {
            tmpList.add(obj);
          }
        }
      }
    } else {
      if (newList != null) {
        tmpList.addAll(newList);
      }
    }
    file
      ..createSync(recursive: true)
      ..writeAsStringSync(json.encode(tmpList));
  }
}

/// 固件返回的BleActivity是累加值时，可以通过这个方法转换成差值记录
/// When the BleActivity returned by the firmware is an accumulated value, it can be converted into a difference record through this method.
/// date: default today，Use today’s timestamp，such as 1690646400000 (2023-07-30)
/// size: default interval is 15 minutes
Future<List> getActivityDiffDetail({int? date, int size = 24 * 4}) async {
  String dateString;
  if (date == null) {
    dateString = getDateString(DateTime.now().millisecondsSinceEpoch);
  } else {
    dateString = getDateString(date);
  }
  DateTime dateTime = DateTime.parse(dateString);
  int startTime = dateTime.millisecondsSinceEpoch;
  int endTime = startTime + 24 * 60 * 60 * 1000;
  BleLog.d("$dateString => $startTime - $endTime");
  String activityDir = "${(await getApplicationDocumentsDirectory()).path}/activity";
  File file = File("$activityDir/$dateString");
  if(await file.exists()) {
    List<dynamic> localList = json.decode(await file.readAsString());
    return getDiffActivity(localList, size, startTime, endTime);
  } else {
    return [];
  }
}

/// 将一天的Activity数据转换成差值数据，用于柱状图显示
/// [data] 从设备获取到的BleActivity，经转换后保存的原始数据
/// [size] 一天的数据分成多少组数据，如按小时分就是24组
List getDiffActivity(List data, int size, int startTime, int endTime) {
  //将数据按时间分组
  int diffTime = (endTime - startTime) ~/ size;
  LinkedHashMap timeData = LinkedHashMap<int, List<dynamic>>();
  for (var index = 1; index <= size; index++) {
    timeData[startTime + index * diffTime] = [];
  }
  for (var item in data) {
    for (var key in timeData.keys) {
      if (item["mActualTime"] <= key) {
        timeData[key].add(item);
        break;
      }
    }
  }

  //计算每组的差值
  List resultData = [];
  int step = 0;
  int calorie = 0;
  int distance = 0;
  Map lasValue = {"mStep": 0, "mCalorie":0, "mDistance": 0};
  timeData.forEach((key, valueList) {
    if ((valueList as List).isEmpty) {
      step = 0;
      calorie = 0;
      distance = 0;
    } else {
      int countStepCR = 0;
      int tmpStepValue = 0;
      int countCalorieCR = 0;
      int tmpCalorieValue = 0;
      int countDistanceCR = 0;
      int tmpDistanceValue = 0;
      for (var activity in valueList) {
        //step
        int tmpStep = activity["mStep"];
        if (tmpStepValue <= tmpStep) {
          int lasStepValue = lasValue["mStep"];
          if (tmpStepValue == 0 && lasStepValue != 0 && tmpStep >= lasStepValue) {
            countStepCR += (tmpStep - lasStepValue);
          } else {
            countStepCR += (tmpStep - tmpStepValue);
          }
        }
        tmpStepValue = tmpStep;

        //Calorie
        int tmpCalorie = activity["mCalorie"];
        if (tmpCalorieValue <= tmpCalorie) {
          int lasCalorieValue = lasValue["mCalorie"];
          if (tmpCalorieValue == 0 && lasCalorieValue != 0 && tmpCalorie >= lasCalorieValue) {
            countCalorieCR += (tmpCalorie - lasCalorieValue);
          } else {
            countCalorieCR += (tmpCalorie - tmpCalorieValue);
          }
        }
        tmpCalorieValue = tmpCalorie;

        //Distance
        int tmpDistance = activity["mDistance"];
        if (tmpDistanceValue <= tmpDistance) {
          int lasDistanceValue = lasValue["mDistance"];
          if (tmpDistanceValue == 0 && lasDistanceValue != 0 && tmpDistance >= lasDistanceValue) {
            countDistanceCR += (tmpDistance - lasDistanceValue);
          } else {
            countDistanceCR += (tmpDistance - tmpDistanceValue);
          }
        }
        tmpDistanceValue = tmpDistance;
      }
      step = countStepCR;
      calorie = countCalorieCR;
      distance = countDistanceCR;
      lasValue = valueList.last;
    }

    Map map = HashMap();
    map["mTime"] = key;
    map["mStep"] = step;
    map["mCalorie"] = calorie;
    map["mDistance"] = distance;
    map["mLocalTime"] = DateTime.fromMillisecondsSinceEpoch(key).toString();
    resultData.add(map);
  });
  return resultData;
}

/// Return cached BleActivity records
/// date: default today，YYYY-MM-DD，such as 2023-07-14
Future<List<BleActivity>> getActivityDetail({int? date}) async {
  String dateString;
  if (date == null) {
    dateString = getDateString(DateTime.now().millisecondsSinceEpoch);
  } else {
    dateString = getDateString(date);
  }
  DateTime dateTime = DateTime.parse(dateString);
  int startTime = dateTime.millisecondsSinceEpoch;
  int endTime = startTime + 24 * 60 * 60 * 1000;
  String activityDir = "${(await getApplicationDocumentsDirectory()).path}/activity";
  BleLog.d("$dateString => $startTime - $endTime");
  File file = File("$activityDir/$dateString");
  if(await file.exists()) {
    List<dynamic> localList = json.decode(await file.readAsString());
    List<BleActivity> tmpList = [];
    for (var local in localList) {
      tmpList.add(BleActivity.fromJson(local));
    }
    return tmpList;
  } else {
    return [];
  }
}

/// [type] 0：BleActivity记录是累加值类型。1：BleActivity记录是差值类型
/// 0：BleActivity records are cumulative value type。
/// 1：BleActivity record is a difference value type。
/// [date] date: default today，Use today’s timestamp，such as 1690646400000 (2023-07-30)
/// [days] Number of days to get
Future<List> getActivityTotal({int? date, int days = 3, int type = 0}) async {
  String dateString;
  if (date == null) {//today
    dateString = getDateString(DateTime.now().millisecondsSinceEpoch);
  } else {
    dateString = getDateString(date);
  }
  List resultData = [];
  for (int i = 0; i < days; i++) {
    int dateTime = DateTime.parse(dateString).millisecondsSinceEpoch - 24 * 60 * 60 * 1000 * i;
    List<BleActivity> tmp = await getActivityDetail(date: dateTime);
    int totalSteps = 0;
    int totalCalories = 0;
    int totalDistance = 0;
    if(type == 1) {//差值
      tmp.forEach((activity) {
        totalSteps = totalSteps + activity.mStep;
        totalCalories = totalCalories + activity.mCalorie;
        totalDistance = totalDistance + activity.mDistance;
      });
    } else {//累加值
      if(tmp.isNotEmpty) {
        BleActivity activity = tmp.last;
        totalSteps = activity.mStep;
        totalCalories = activity.mCalorie;
        totalDistance = activity.mDistance;
      }
    }
    Map map = HashMap();
    map["date"] = dateTime;
    map["totalSteps"] = totalSteps;
    map["totalCalories"] = totalCalories;
    map["totalDistance"] = totalDistance;
    resultData.add(map);
  }
  return resultData;
}
