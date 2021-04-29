#import "BetterAudioCapturePlugin.h"
#import "BetterAudioCaptureEventSink.h"
#import <AVFoundation/AVFoundation.h>

@interface BetterAudioCapturePlugin () {
    dispatch_queue_t audioProcessingQueue;
}

@property (nonatomic, strong) BetterAudioCaptureEventSink *eventSink;


@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) AVAudioFormat *inputFormat;
@property (nonatomic, strong) AVAudioFormat *outputFormat;

@end

@implementation BetterAudioCapturePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BetterAudioCapturePlugin* instance = [[BetterAudioCapturePlugin alloc] init];
    [BetterAudioCaptureApi setup:[registrar messenger] api:instance];
}

- (void)initWithSampleRate:(NSInteger)sampleRate channelCount:(NSInteger)channelCount {
    
    _outputFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16 sampleRate:sampleRate channels:(uint32_t)channelCount interleaved:false];
}


- (void)startCaptureWithEventSink:(BetterAudioCaptureEventSink *)eventSink {
    if (self.audioEngine.isRunning) {
        return;
    }
    self.eventSink = eventSink;
        
    _audioEngine = [[AVAudioEngine alloc] init];
    _inputFormat = [self.audioEngine.inputNode  outputFormatForBus:0];
    
    __block AVAudioConverter *converter = [[AVAudioConverter alloc] initFromFormat:self.inputFormat toFormat:self.outputFormat];
    
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
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (ws.eventSink && data) {
                ws.eventSink.event(data);
            }
        });
    }];
    
    NSError *error = nil;
    [self.audioEngine prepare];
    if (![self.audioEngine startAndReturnError:&error]) {
        NSLog(@"wang %@", error.userInfo);
    }}


- (void)stopCapture {
    if (self.audioEngine.isRunning) {
        [self.audioEngine.inputNode removeTapOnBus:0];
        [self.audioEngine stop];
    }
}

- (void)dispose {
    [self stopCapture];
}

@end
