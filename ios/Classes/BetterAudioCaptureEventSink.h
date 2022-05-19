//
//  BetterAudioCaptureEventSink.h
//  Pods
//
//  Created by 汪洋 on 2022/5/11.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface BetterAudioCaptureEventSink : NSObject <FlutterStreamHandler>

@property (nonatomic, copy) FlutterEventSink event;

@end
