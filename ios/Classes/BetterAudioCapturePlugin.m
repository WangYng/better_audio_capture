//
//  BetterAudioCapturePlugin.m
//  Pods
//
//  Created by 汪洋 on 2022/5/11.
//

#import "BetterAudioCapturePlugin.h"
#import "BetterAudioCaptureEventSink.h"
#import "BetterAudioCapture.h"

@interface BetterAudioCapturePlugin()

@property(nonatomic, strong)BetterAudioCaptureEventSink *resultStream;

@property(nonatomic, strong)NSMutableDictionary *instanceMap;

@end

@implementation BetterAudioCapturePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    BetterAudioCapturePlugin* instance = [[BetterAudioCapturePlugin alloc] init];
    [BetterAudioCaptureApi setup:registrar api:instance];
}

- (void)initWithInstanceId:(NSInteger)instanceId sampleRate:(NSInteger)sampleRate channelCount:(NSInteger)channelCount {
    BetterAudioCapture *audioRecord = [[BetterAudioCapture alloc] init];
    [audioRecord initWithSampleRate:sampleRate channelCount:channelCount];
    
    if (self.instanceMap == nil) {
        self.instanceMap = [[NSMutableDictionary alloc] init];
    }
    self.instanceMap[@(instanceId)] = audioRecord;
}

- (void)startCaptureWithInstanceId:(NSInteger)instanceId {
    if (self.instanceMap == nil) {
        self.instanceMap = [[NSMutableDictionary alloc] init];
    }
    BetterAudioCapture *audioRecord = self.instanceMap[@(instanceId)];
    [audioRecord startCaptureWithCallback:^(NSData *data) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self.resultStream.event != nil) {
                self.resultStream.event(@{@"instanceId": @(instanceId), @"pcm": data});
            }
        });
    }];
}

- (void)stopCaptureWithInstanceId:(NSInteger)instanceId {
    if (self.instanceMap == nil) {
        self.instanceMap = [[NSMutableDictionary alloc] init];
    }
    BetterAudioCapture *audioRecord = self.instanceMap[@(instanceId)];
    [audioRecord stopCapture];
}

- (void)disposeWithInstanceId:(NSInteger)instanceId {
    if (self.instanceMap == nil) {
        self.instanceMap = [[NSMutableDictionary alloc] init];
    }
    BetterAudioCapture *audioRecord = self.instanceMap[@(instanceId)];
    if (audioRecord != nil) {
        [audioRecord dispose];
        [self.instanceMap removeObjectForKey:@(instanceId)];
    }
}

@end
