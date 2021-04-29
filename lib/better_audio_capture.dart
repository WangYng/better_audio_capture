import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:better_audio_capture/better_audio_capture_api.dart';
import 'package:better_audio_capture/better_audio_capture_helper.dart';
import 'package:flutter/services.dart';

class BetterAudioCapture {
  final _api = BetterAudioCaptureApi();

  late int sampleRate;
  late int channelCount;

  Future<void> init({int sampleRate = 16000, int channelCount = 1}) async {
    this.sampleRate = sampleRate;
    this.channelCount = channelCount;

    await _api.init(sampleRate, channelCount);
  }

  Future<Stream<Uint8List>> startCapture() async {
    Stream stream = await _api.startCapture();
    return stream.map((event) => event as Uint8List);
  }

  Future<void> stopCapture() async {
    return _api.stopCapture();
  }

  Future<void> dispose() async {
    return _api.dispose();
  }

  Uint8List waveHeader(int size) {
    return WaveHeader(
      WaveHeader.formatPCM,
      channelCount, //
      sampleRate,
      16, // 16 bits per byte
      size, // total number of bytes
    ).bytes();
  }
}
