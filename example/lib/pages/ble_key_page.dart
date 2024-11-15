import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class BleKeyPage extends StatefulWidget {
  final BleCommand mBleCommand;

  const BleKeyPage(this.mBleCommand);

  @override
  State<BleKeyPage> createState() => _BleKeyPageState();
}

class _BleKeyPageState extends State<BleKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("BleKey"),
        ),
        body: ListView.builder(
            itemCount: widget.mBleCommand.getBleKeys().length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(widget.mBleCommand.getBleKeys()[i].toString()),
                onTap: () {
                  Navigator.of(context).pushNamed("/bleKeyFlag",
                      arguments: widget.mBleCommand.getBleKeys()[i]);
                },
              );
            }));
  }
}
