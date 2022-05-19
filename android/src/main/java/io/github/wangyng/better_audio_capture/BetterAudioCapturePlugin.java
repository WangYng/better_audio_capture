package io.github.wangyng.better_audio_capture;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

public class BetterAudioCapturePlugin implements FlutterPlugin, BetterAudioCaptureApi {

    private Handler handler;

    private final Map<Integer, BetterAudioCapture> instanceMap = new HashMap<>();

    private BetterAudioCaptureEventSink resultStream;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BetterAudioCaptureApi.setup(binding, this, binding.getApplicationContext());
        handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        BetterAudioCaptureApi.setup(binding, null, null);
        handler = null;
    }


    @Override
    public void setResultStream(Context context, BetterAudioCaptureEventSink resultStream) {
        this.resultStream = resultStream;
    }

    @Override
    public void init(Context context, int instanceId, int sampleRate, int channelCount) {
        BetterAudioCapture audioRecord = new BetterAudioCapture();
        audioRecord.init(sampleRate, channelCount);

        instanceMap.put(instanceId, audioRecord);
    }

    @Override
    public void startCapture(Context context, int instanceId) {
        BetterAudioCapture audioRecord = instanceMap.get(instanceId);
        if (audioRecord != null) {
            audioRecord.startCapture((data) -> {
                if (handler != null) {
                    handler.post(() -> {
                        if (resultStream != null && resultStream.event != null ) {
                            // 返回结果
                            Map<String, Object> result = new HashMap<>();
                            result.put("instanceId", instanceId);
                            result.put("pcm", data);
                            resultStream.event.success(result);
                        }
                    });
                }
            });
        }
    }

    @Override
    public void stopCapture(Context context, int instanceId) {
        BetterAudioCapture audioRecord = instanceMap.get(instanceId);
        if (audioRecord != null) {
            audioRecord.stopCapture();
        }
    }

    @Override
    public void dispose(Context context, int instanceId) {
        BetterAudioCapture audioRecord = instanceMap.remove(instanceId);
        if (audioRecord != null) {
            audioRecord.dispose();
        }
    }
}
