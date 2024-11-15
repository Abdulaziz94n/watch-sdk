import 'package:sma_coding_dev_flutter_sdk_example/main.dart';
import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class BleCommandPage extends StatefulWidget {
  const BleCommandPage({Key? key}) : super(key: key);

  @override
  State<BleCommandPage> createState() => _BleCommandPageState();
}

class _BleCommandPageState extends State<BleCommandPage>
    with BleHandleCallback {
  @override
  void initState() {
    super.initState();
    BleConnector.getInstance.addHandleCallback(this);
  }

  @override
  void dispose() {
    BleConnector.getInstance.removeHandleCallback(this);
    super.dispose();
  }

  @override
  void onSessionStateChange(bool status) {
    showToast("onSessionStateChange $status");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BleCommand"),
        ),
        body: ListView.builder(
            itemCount: BleCommand.values.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(BleCommand.values[i].toString()),
                onTap: () {
                  if (BleCommand.values[i] == BleCommand.NONE) {
                    Navigator.of(context).pushNamed('/other_page');
                  } else {
                    Navigator.of(context)
                        .pushNamed("/bleKey", arguments: BleCommand.values[i]);
                  }
                },
              );
            }));
  }
}
