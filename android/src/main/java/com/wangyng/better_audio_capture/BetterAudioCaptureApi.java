package com.wangyng.better_audio_capture;

import android.content.Context;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public interface BetterAudioCaptureApi {

    // 初始化
    void init(int sampleRate, int channelCount);

    // 开始获取数据
    void startCapture(QueuingEventSink eventSink);

    // 结束获取数据
    void stopCapture();

    // 销毁环境
    void dispose();

    static void setup(BinaryMessenger binaryMessenger, BetterAudioCaptureApi api) {
        { // init
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_audio_capture.init", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        int sampleRate = Integer.parseInt(params.get("sampleRate").toString());
                        int channelCount = Integer.parseInt(params.get("channelCount").toString());

                        api.init(sampleRate, channelCount);

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // startCapture
            EventChannel eventChannel = new EventChannel(binaryMessenger, "com.wangyng.better_audio_capture/captureListenerEvent");
            QueuingEventSink eventSink = new QueuingEventSink();
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_audio_capture.startCapture", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        api.startCapture(eventSink);

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
                eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink.setDelegate(events);
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        eventSink.setDelegate(null);
                    }
                });
            } else {
                channel.setMessageHandler(null);
                eventChannel.setStreamHandler(null);
            }
        }
        { // stopCapture
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_audio_capture.stopCapture", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        api.stopCapture();

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
        { // dispose
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "com.wangyng.better_audio_capture.dispose", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, HashMap<String, Object>> wrapped = new HashMap<>();
                    try {
                        api.dispose();

                        wrapped.put("result", null);
                    } catch (Exception exception) {
                        wrapped.put("error", wrapError(exception));
                    }
                    reply.reply(wrapped);
                });
            } else {
                channel.setMessageHandler(null);
            }
        }
    }

    static HashMap<String, Object> wrapError(Exception exception) {
        HashMap<String, Object> errorMap = new HashMap<>();
        errorMap.put("message", exception.toString());
        errorMap.put("code", null);
        errorMap.put("details", null);
        return errorMap;
    }
}
