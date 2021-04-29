import 'dart:collection';

import 'package:flutter/services.dart';

class BetterAudioCaptureApi {
  Future<void> init(int sampleRate, int channelCount) async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_audio_capture.init', StandardMessageCodec());
    final Map<String, dynamic> requestMap = {
      "sampleRate": sampleRate,
      "channelCount": channelCount,
    };
    final reply = await channel.send(requestMap);

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }

  Future<Stream> startCapture() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_audio_capture.startCapture', StandardMessageCodec());
    final reply = await channel.send({});

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }

    return EventChannel("com.wangyng.better_audio_capture/captureListenerEvent").receiveBroadcastStream();
  }

  Future<void> stopCapture() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_audio_capture.stopCapture', StandardMessageCodec());
    final reply = await channel.send({});

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }

  Future<void> dispose() async {
    const channel = BasicMessageChannel<dynamic>('com.wangyng.better_audio_capture.dispose', StandardMessageCodec());
    final reply = await channel.send({});

    if (!(reply is Map)) {
      _throwChannelException();
    }

    Map<String, dynamic> replyMap = Map<String, dynamic>.from(reply);
    if (replyMap['error'] != null) {
      final HashMap<String, dynamic> error = replyMap['error'];
      _throwException(error);
    } else {
      // noop
    }
  }
}

_throwChannelException() {
  throw PlatformException(code: 'channel-error', message: 'Unable to establish connection on channel.', details: null);
}

_throwException(HashMap<String, dynamic> error) {
  throw PlatformException(code: error['code'], message: error['message'], details: error['details']);
}
