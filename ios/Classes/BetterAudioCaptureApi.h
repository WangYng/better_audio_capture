//
//  BetterAudioCaptureApi.h
//  Pods
//
//  Created by 汪洋 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "BetterAudioCaptureEventSink.h"

@protocol BetterAudioCaptureApiDelegate <NSObject>

// 初始化SDK
- (void)initWithSampleRate:(NSInteger)sampleRate channelCount:(NSInteger)channelCount;

// 开始获取数据
- (void)startCaptureWithEventSink:(BetterAudioCaptureEventSink *)eventSink;

// 结束获取数据
- (void)stopCapture;

// 销毁环境
- (void)dispose;

@end

@interface BetterAudioCaptureApi : NSObject

+ (void)setup:(NSObject<FlutterBinaryMessenger> *)messenger api:(id<BetterAudioCaptureApiDelegate>)api;

@end
