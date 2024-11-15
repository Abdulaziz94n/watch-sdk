import 'package:flutter/material.dart';
import 'package:sma_coding_dev_flutter_sdk/sma_coding_dev_flutter_sdk.dart';

class MusicControlPage extends StatefulWidget {

  const MusicControlPage({super.key});

  @override
  State<MusicControlPage> createState() => _MusicControlPageState();
}

class _MusicControlPageState extends State<MusicControlPage>  with BleHandleCallback {
  String text = "";

  @override
  void onReceiveMusicCommand(int musicCommand) {
    setState(() {
      text = "Command: $musicCommand";
    });
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Control"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            MaterialButton(
              onPressed: () {
                BleConnector.getInstance.sendMusicPlayState(PlayState.PLAYING);
              },
              textColor: Colors.white,
              color: Colors.blue[200],
              child: const Text("sendMusicPlayState(PlayState.PLAYING)"),
            ),
            MaterialButton(
              onPressed: () {
                BleConnector.getInstance.sendMusicPlayState(PlayState.PAUSED);
              },
              textColor: Colors.white,
              color: Colors.blue[200],
              child: const Text("sendMusicPlayState(PlayState.PAUSED)"),
            ),
            MaterialButton(
              onPressed: () {
                BleConnector.getInstance.sendMusicTitle("aaa11");
              },
              textColor: Colors.white,
              color: Colors.blue[200],
              child: const Text("sendMusicTitle()"),
            ),
            MaterialButton(
              onPressed: () {
                //0-100
                BleConnector.getInstance.sendPhoneVolume(10);
              },
              textColor: Colors.white,
              color: Colors.blue[200],
              child: const Text("sendPhoneVolume()"),
            )
          ],
        ),
      )
    );
  }
}

