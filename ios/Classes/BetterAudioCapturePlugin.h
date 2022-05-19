//
//  BetterAudioCapturePlugin.h
//  Pods
//
//  Created by 汪洋 on 2022/5/11.
//

#import <Flutter/Flutter.h>
#import "BetterAudioCaptureApi.h"

@interface BetterAudioCapturePlugin : NSObject<BetterAudioCaptureApiDelegate>

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end
