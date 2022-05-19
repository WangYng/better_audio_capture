import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class BetterAudioCaptureApi {

  static Stream resultStream = EventChannel("io.github.wangyng.better_audio_capture/resultStream").receiveBroadcastStream();

  static Future<void> init({required int instanceId, required int sampleRate, required int channelCount}) async {
    const channel = BasicMessageChannel<dynamic>('io.github.wangyng.better_audio_capture.init', StandardMessageCodec());

    final Map<String, dynamic> requestMap = {};
    requestMap["instanceId"] = instanceId;
    requestMap["sampleRate"] = sampleRate;
    requestMap["channelCount"] = channelCount;
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
      
    } else {
      // noop
    }
  }

  static Future<void> startCapture({required int instanceId}) async {
    const channel = BasicMessageChannel<dynamic>('io.github.wangyng.better_audio_capture.startCapture', StandardMessageCodec());

    final Map<String, dynamic> requestMap = {};
    requestMap["instanceId"] = instanceId;
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
      
    } else {
      // noop
    }
  }

  static Future<void> stopCapture({required int instanceId}) async {
    const channel = BasicMessageChannel<dynamic>('io.github.wangyng.better_audio_capture.stopCapture', StandardMessageCodec());

    final Map<String, dynamic> requestMap = {};
    requestMap["instanceId"] = instanceId;
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
      
    } else {
      // noop
    }
  }

  static Future<void> dispose({required int instanceId}) async {
    const channel = BasicMessageChannel<dynamic>('io.github.wangyng.better_audio_capture.dispose', StandardMessageCodec());

    final Map<String, dynamic> requestMap = {};
    requestMap["instanceId"] = instanceId;
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    final replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final error = Map<String, dynamic>.from(replyMap['error']);
      _throwException(error);
      
    } else {
      // noop
    }
  }

}

_throwChannelException() {
  throw PlatformException(code: 'channel-error', message: 'Unable to establish connection on channel.', details: null);
}

_throwException(Map<String, dynamic> error) {
  throw PlatformException(code: "${error['code']}", message: "${error['message']}", details: "${error['details']}");
}
