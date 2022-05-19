package io.github.wangyng.better_audio_capture;

import android.content.Context;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.StandardMessageCodec;

public interface BetterAudioCaptureApi {

    void setResultStream(Context context, BetterAudioCaptureEventSink resultStream);

    void init(Context context, int instanceId, int sampleRate, int channelCount);

    void startCapture(Context context, int instanceId);

    void stopCapture(Context context, int instanceId);

    void dispose(Context context, int instanceId);

    static void setup(FlutterPlugin.FlutterPluginBinding binding, BetterAudioCaptureApi api, Context context) {
        BinaryMessenger binaryMessenger = binding.getBinaryMessenger();

        {
            EventChannel eventChannel = new EventChannel(binaryMessenger, "io.github.wangyng.better_audio_capture/resultStream");
            BetterAudioCaptureEventSink eventSink = new BetterAudioCaptureEventSink();
            if (api != null) {
                eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink.event = events;
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        eventSink.event = null;
                    }
                });
                api.setResultStream(context, eventSink);
            } else {
                eventChannel.setStreamHandler(null);
            }
        }

        {
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "io.github.wangyng.better_audio_capture.init", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, Object> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        int instanceId = (int)params.get("instanceId");
                        int sampleRate = (int)params.get("sampleRate");
                        int channelCount = (int)params.get("channelCount");
                        api.init(context, instanceId, sampleRate, channelCount);
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

        {
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "io.github.wangyng.better_audio_capture.startCapture", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, Object> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        int instanceId = (int)params.get("instanceId");
                        api.startCapture(context, instanceId);
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

        {
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "io.github.wangyng.better_audio_capture.stopCapture", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, Object> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        int instanceId = (int)params.get("instanceId");
                        api.stopCapture(context, instanceId);
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

        {
            BasicMessageChannel<Object> channel = new BasicMessageChannel<>(binaryMessenger, "io.github.wangyng.better_audio_capture.dispose", new StandardMessageCodec());
            if (api != null) {
                channel.setMessageHandler((message, reply) -> {
                    Map<String, Object> wrapped = new HashMap<>();
                    try {
                        HashMap<String, Object> params = (HashMap<String, Object>) message;
                        int instanceId = (int)params.get("instanceId");
                        api.dispose(context, instanceId);
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
