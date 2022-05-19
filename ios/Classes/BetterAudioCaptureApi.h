//
//  BetterAudioCaptureApi.h
//  Pods
//
//  Created by 汪洋 on 2022/5/11.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "BetterAudioCaptureEventSink.h"

@protocol BetterAudioCaptureApiDelegate <NSObject>

- (void)setResultStream:(BetterAudioCaptureEventSink *)resultStream;

- (void)initWithInstanceId:(NSInteger)instanceId sampleRate:(NSInteger)sampleRate channelCount:(NSInteger)channelCount;

- (void)startCaptureWithInstanceId:(NSInteger)instanceId;

- (void)stopCaptureWithInstanceId:(NSInteger)instanceId;

- (void)disposeWithInstanceId:(NSInteger)instanceId;

@end

@interface BetterAudioCaptureApi : NSObject

+ (void)setup:(NSObject<FlutterPluginRegistrar> *)registrar api:(id<BetterAudioCaptureApiDelegate>)api;

@end

