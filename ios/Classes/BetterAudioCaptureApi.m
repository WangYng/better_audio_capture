//
//  BetterAudioCaptureApi.m
//  Pods
//
//  Created by 汪洋 on 2021/4/29.
//

#import "BetterAudioCaptureApi.h"

@implementation BetterAudioCaptureApi

+ (void)setup:(NSObject<FlutterBinaryMessenger> *)messenger api:(id<BetterAudioCaptureApiDelegate>)api {
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_audio_capture.init" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *params = message;
                    NSInteger sampleRate = [params[@"sampleRate"] integerValue];
                    NSInteger channelCount = [params[@"channelCount"] integerValue];

                    [api initWithSampleRate:sampleRate channelCount:channelCount];
                    
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
        FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"com.wangyng.better_audio_capture/captureListenerEvent" binaryMessenger:messenger];
        BetterAudioCaptureEventSink *eventSink = [[BetterAudioCaptureEventSink alloc] init];
        
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_audio_capture.startCapture" binaryMessenger:messenger];

        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {

                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                if ([message isKindOfClass:[NSDictionary class]]) {
                    
                    [api startCaptureWithEventSink:eventSink];
                    
                    wrapped[@"result"] = nil;
                } else {
                    wrapped[@"error"] = @{@"message": @"parse message error"};
                }
                reply(wrapped);
            }];
            [eventChannel setStreamHandler:eventSink];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_audio_capture.stopCapture" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {

                [api stopCapture];
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                wrapped[@"result"] = nil;
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
    
    {
        FlutterBasicMessageChannel *channel =[FlutterBasicMessageChannel messageChannelWithName:@"com.wangyng.better_audio_capture.dispose" binaryMessenger:messenger];
        
        if (api != nil) {
            [channel setMessageHandler:^(id  message, FlutterReply reply) {

                [api dispose];
                
                NSMutableDictionary<NSString *, NSObject *> *wrapped = [NSMutableDictionary new];
                wrapped[@"result"] = nil;
                reply(wrapped);
            }];
        } else {
            [channel setMessageHandler:nil];
        }
    }
}

@end
