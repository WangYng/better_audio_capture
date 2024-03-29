//
//  BetterAudioCapture.m
//  better_audio_capture
//
//  Created by wangyang on 2022/5/11.
//

#import "BetterAudioCapture.h"
#import <AVFoundation/AVFoundation.h>

@interface BetterAudioCapture (){
    dispatch_queue_t audioProcessingQueue;
}

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioFormat *inputFormat;
@property (nonatomic, strong) AVAudioFormat *outputFormat;

@end

@implementation BetterAudioCapture

- (void)initWithSampleRate:(NSInteger)sampleRate channelCount:(NSInteger)channelCount {
    _outputFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16 sampleRate:sampleRate channels:(uint32_t)channelCount interleaved:false];
}

- (void)startCaptureWithCallback:(BetterAudioCaptureBlock)callback {
    if (self.audioEngine.isRunning) {
        return;
    }
        
    NSError *error = nil;
    [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
    [AVAudioSession.sharedInstance setMode:AVAudioSessionModeMeasurement error:&error];
    [AVAudioSession.sharedInstance setActive:YES error:&error];
    
    if (error != nil) {
        NSLog(@"麦克风被其它应用程序占用");
        return;
    }
    
    _audioEngine = [[AVAudioEngine alloc] init];
    
    AVAudioFormat *recorderFormat = [self.audioEngine.inputNode  inputFormatForBus:0];
    
    if (recorderFormat.sampleRate == 0 || recorderFormat.channelCount == 0) {
        NSLog(@"麦克风被其它应用程序占用");
        return;
    }

    _inputFormat = [[AVAudioFormat alloc] initWithCommonFormat:recorderFormat.commonFormat sampleRate:recorderFormat.sampleRate channels:recorderFormat.channelCount interleaved:recorderFormat.interleaved];
        
    __block AVAudioConverter *converter = [[AVAudioConverter alloc] initFromFormat:self.inputFormat toFormat:self.outputFormat];
        
    @try {
        int bufferSize = 1024;

        __weak typeof(self) ws = self;
        [self.audioEngine.inputNode installTapOnBus:0 bufferSize:bufferSize format:self.inputFormat block:^(AVAudioPCMBuffer *_Nonnull buffer, AVAudioTime *_Nonnull when) {
            
            AVAudioFrameCount resampledFrameSize = buffer.frameCapacity * (ws.outputFormat.sampleRate / ws.inputFormat.sampleRate);
            
            AVAudioPCMBuffer *outputBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:ws.outputFormat frameCapacity:resampledFrameSize];
            
            NSError *resamplingError = nil;
            
            [converter convertToBuffer:outputBuffer error:&resamplingError withInputFromBlock:^AVAudioBuffer *(AVAudioPacketCount inNumberOfPackets, AVAudioConverterInputStatus *outStatus) {
                *outStatus = AVAudioConverterInputStatus_HaveData;
                return buffer;
            }];
            
            __block NSData *data = [[NSData alloc] initWithBytes:outputBuffer.int16ChannelData[0] length:outputBuffer.frameLength * sizeof(int16_t)];
            
            if (callback) {
                callback(data);
            }
        }];
        
        [self.audioEngine prepare];
        if (![self.audioEngine startAndReturnError:&error]) {
            NSLog(@"%@", error.userInfo);
        }
    } @catch (NSException *exception) {
        NSLog(@"麦克风被其它应用程序占用");
    }
}

- (void)stopCapture {
    if (self.audioEngine.isRunning) {
        [self.audioEngine.inputNode removeTapOnBus:0];
        [self.audioEngine stop];
    }
    _audioEngine = nil;
}

- (void)dispose {
    [self stopCapture];
}

@end
