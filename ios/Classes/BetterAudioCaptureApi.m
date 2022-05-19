//
//  BetterAudioCaptureApi.m
//  Pods
//
//  Created by 汪洋 on 2022/5/11.
//

#import "BetterAudioCaptureApi.h"

@implementation BetterAudioCaptureApi

+ (void)setup:(NSObject<FlutterPluginRegistrar> *)registrar api:(id<BetterAudioCaptureApiDelegate>)api {
    NSObject<FlutterBinaryMessenger> *messenger = [registrar messenger];

    {
        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"io.github.wangyng.better_audio_capture/resultStream" binaryMessenger:messenger];
        BetterAudioCaptureEventSink *eventSink = [[BetterAudioCaptureEventSink alloc] init];
        if (api != nil) {
            [eventChannel setStreamHandler:eventSink];
            [api setResultStream:eventSink];
        }
    }

    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"io.github.wangyng.better_audio_capture.init" binaryMessenger:messenger];
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *params = message;
                    NSInteger instanceId = [params[@"instanceId"] integerValue];
                    NSInteger sampleRate = [params[@"sampleRate"] integerValue];
                    NSInteger channelCount = [params[@"channelCount"] integerValue];
                    [api initWithInstanceId:instanceId sampleRate:sampleRate channelCount:channelCount];
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }

    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"io.github.wangyng.better_audio_capture.startCapture" binaryMessenger:messenger];
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *params = message;
                    NSInteger instanceId = [params[@"instanceId"] integerValue];
                    [api startCaptureWithInstanceId:instanceId];
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }

    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"io.github.wangyng.better_audio_capture.stopCapture" binaryMessenger:messenger];
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *params = message;
                    NSInteger instanceId = [params[@"instanceId"] integerValue];
                    [api stopCaptureWithInstanceId:instanceId];
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }

    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"io.github.wangyng.better_audio_capture.dispose" binaryMessenger:messenger];
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *params = message;
                    NSInteger instanceId = [params[@"instanceId"] integerValue];
                    [api disposeWithInstanceId:instanceId];
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }

}

@end
