import 'dart:async';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  final _totalTime = 2.0;
  late Timer _timer;
  late num _value;

  @override
  void initState() {
    super.initState();
    _value = _totalTime;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_value == 0) {
        _timer.cancel();
        toNextPage();
        return;
      }
      setState(() {
        _value--;
      });
    });
  }

  void toNextPage() async {
    if (await BleConnector.getInstance.isBound()) {
      Navigator.of(context).popAndPushNamed('/bleCommand');
    } else {
      Navigator.of(context).popAndPushNamed("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(color: Colors.blue),
        child: Center(
          child: Text(
            'SMA',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(50),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }
}
