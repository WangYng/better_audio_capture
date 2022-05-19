import 'dart:typed_data';

import 'package:better_audio_capture/better_audio_capture_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:better_audio_capture/better_audio_capture_api.dart';

class BetterAudioCapture {

  static int _firstInstanceId = 1;

  final int instanceId = _firstInstanceId++;

  late Stream<Uint8List> pcmStream;

  int sampleRate = 16000;

  int channelCount = 1;

  BetterAudioCapture() {
    pcmStream = BetterAudioCaptureApi.resultStream.where((event) {
      if (event is Map) {
        final instanceId = int.tryParse(event["instanceId"]?.toString() ?? "") ?? -1;
        return instanceId == this.instanceId;
      }
      return false;
    }).map<Uint8List>((event) {
      return event["pcm"] as Uint8List;
    });
  }

  Future<void> init({int sampleRate = 16000, int channelCount = 1}) async {
    this.sampleRate = sampleRate;
    this.channelCount = channelCount;

    await BetterAudioCaptureApi.init(instanceId: instanceId, sampleRate: sampleRate, channelCount: channelCount);
  }

  Future<void> startCapture() async {
    return BetterAudioCaptureApi.startCapture(instanceId: instanceId);
  }

  Future<void> stopCapture() async {
    return BetterAudioCaptureApi.stopCapture(instanceId: instanceId);
  }

  Future<void> dispose() async {
    return BetterAudioCaptureApi.dispose(instanceId: instanceId);
  }

  static Uint8List waveHeader(int size, {int sampleRate = 16000, int channelCount = 1}) {
    return WaveHeader(
      WaveHeader.formatPCM,
      channelCount, //
      sampleRate,
      16, // 16 bits per byte
      size, // total number of bytes
    ).bytes();
  }
}

