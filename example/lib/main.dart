import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:better_audio_capture/better_audio_capture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PermissionStatus? permissionStatus;

  BetterAudioCapture betterAudioCapture = BetterAudioCapture();

  StreamSubscription? subscription;

  BytesBuilder bytesBuilder = BytesBuilder();

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      PermissionStatus permissionStatus = await Permission.microphone.status;
      setState(() {
        this.permissionStatus = permissionStatus;
      });
    });

    betterAudioCapture.init();
  }

  @override
  void dispose() {
    subscription?.cancel();
    betterAudioCapture.dispose();
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Offstage(
                offstage: permissionStatus == PermissionStatus.granted,
                child: CupertinoButton(
                  child: Text("request microphone permission"),
                  onPressed: () async {
                    final value = await Permission.microphone.request();
                    if (value == PermissionStatus.permanentlyDenied || value == PermissionStatus.restricted) {
                      openAppSettings();
                    }

                    setState(() {
                      permissionStatus = value;
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Text("start"),
                onPressed: () async {
                  bytesBuilder.clear();

                  // request audio session
                  final session = await AudioSession.instance;
                  await session.configure(AudioSessionConfiguration(
                    avAudioSessionCategory: AVAudioSessionCategory.record,
                    avAudioSessionMode: AVAudioSessionMode.measurement,
                    avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
                    avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
                  ));
                  if (await session.setActive(true)) {

                    betterAudioCapture.startCapture().then((Stream<Uint8List> stream) {
                      subscription = stream.listen((event) {
                        bytesBuilder.add(event);
                      });
                    });
                  }
                },
              ),
              CupertinoButton(
                child: Text("stop"),
                onPressed: () async {
                  betterAudioCapture.stopCapture();
                  subscription?.cancel();

                  Directory tempDir = await getTemporaryDirectory();
                  File waveFile = File(tempDir.path + "/record.wav");
                  if (waveFile.existsSync()) {
                    waveFile.deleteSync();
                  }

                  // 写入wav文件
                  IOSink waveFileSink = waveFile.openWrite();
                  waveFileSink.add(betterAudioCapture.waveHeader(bytesBuilder.length));
                  waveFileSink.add(bytesBuilder.takeBytes());
                  await waveFileSink.close();
                },
              ),
              CupertinoButton(
                child: Text("play"),
                onPressed: () async {
                  Directory tempDir = await getTemporaryDirectory();
                  File waveFile = File(tempDir.path + "/record.wav");

                  if (waveFile.existsSync()) {

                    // request audio session
                    final session = await AudioSession.instance;
                    await session.configure(AudioSessionConfiguration.speech());

                    if (await session.setActive(true)) {
                      audioPlayer = AudioPlayer();
                      audioPlayer.setFilePath(waveFile.path);
                      audioPlayer.play();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
