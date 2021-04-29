package com.wangyng.better_audio_capture;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;

import androidx.annotation.NonNull;

import java.nio.ByteBuffer;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * BetterAudioCapturePlugin
 */
public class BetterAudioCapturePlugin implements FlutterPlugin, BetterAudioCaptureApi {

    Handler handler;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BetterAudioCaptureApi.setup(binding.getBinaryMessenger(), this);
        handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        BetterAudioCaptureApi.setup(binding.getBinaryMessenger(), null);
        handler = null;
    }

    private AudioRecord audioRecord;

    private int bufferSize;

    private final Lock lock = new ReentrantLock();
    private boolean isStop;

    @Override
    public void init(int sampleRate, int channelCount) {
        int audioChannel = AudioFormat.CHANNEL_IN_MONO;   //单声道
        int audioFormat = AudioFormat.ENCODING_PCM_16BIT; //音频录制格式

        if (channelCount == 2) {
            audioChannel = AudioFormat.CHANNEL_IN_STEREO; // 立体声
        }

        bufferSize = AudioRecord.getMinBufferSize(sampleRate, audioChannel, audioFormat);
        audioRecord = new AudioRecord(MediaRecorder.AudioSource.MIC, sampleRate, audioChannel,
                audioFormat, bufferSize);
    }

    @Override
    public void startCapture(QueuingEventSink eventSink) {
        audioRecord.startRecording();
        isStop = false;

        new Thread() {
            @Override
            public void run() {
                ByteBuffer audioBuffer = ByteBuffer.allocateDirect(bufferSize);

                while (true) {

                    lock.lock();

                    if (isStop) {
                        lock.unlock();
                        return;
                    }
                    audioBuffer.clear();

                    int readSize = audioRecord.read(audioBuffer, bufferSize);
                    if (readSize != AudioRecord.ERROR_INVALID_OPERATION) {

                        byte[] buffer = new byte[audioBuffer.remaining()];
                        audioBuffer.get(buffer);

                        if (handler != null) {
                            handler.post(() -> eventSink.success(buffer));
                        }
                    }

                    lock.unlock();

                    // 休息一会, 释放锁资源
                    SystemClock.sleep(1);
                }
            }
        }.start();
    }

    @Override
    public void stopCapture() {
        lock.lock();

        audioRecord.stop();
        isStop = true;

        lock.unlock();
    }

    @Override
    public void dispose() {
        audioRecord.release();
    }
}
