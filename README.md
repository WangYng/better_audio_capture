# better_audio_capture

A simple audio capture for Flutter.

## Install Started

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_audio_capture: ^0.0.1
```

2. Install it

```bash
$ flutter packages get
```

## Normal usage

```dart
  @override
  void initState() {
    super.initState();

    betterAudioCapture.init();
  }

  @override
  void dispose() {
    subscription?.cancel();
    betterAudioCapture.dispose();

    super.dispose();
  }

  
  CupertinoButton(
    child: Text("start capture"),
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
    child: Text("stop capture"),
    onPressed: () async {
      betterAudioCapture.stopCapture();
      subscription?.cancel();

      Directory tempDir = await getTemporaryDirectory();
      File waveFile = File(tempDir.path + "/record.wav");
      if (waveFile.existsSync()) {
        waveFile.deleteSync();
      }

      IOSink waveFileSink = waveFile.openWrite();
      waveFileSink.add(betterAudioCapture.waveHeader(bytesBuilder.length));
      waveFileSink.add(bytesBuilder.takeBytes());
      await waveFileSink.close();
    },
  ),
```

## Feature
- [x] Audio capture by microphone.
- [x] Set audio stream sampleRate.
- [x] Set audio stream channelNumber.
