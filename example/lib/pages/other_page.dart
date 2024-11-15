import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class OtherPage extends StatefulWidget {

  const OtherPage({super.key});

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Other"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/firmware_repair_scan_page');
              },
              textColor: Colors.white,
              color: Colors.blue[200],
              child: const Text("Firmware Repair"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/music_control_page');
              },
              textColor: Colors.white,
              color: Colors.blue[200],
              child: const Text("Music Control")
            )
          ],
        ),
      )
    );
  }
}

