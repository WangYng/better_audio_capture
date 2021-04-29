//
//  BetterAudioCaptureEventSink.h
//  Pods
//
//  Created by 汪洋 on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface BetterAudioCaptureEventSink : NSObject <FlutterStreamHandler>

@property (nonatomic, copy) FlutterEventSink event;

@end
