//
//  BetterAudioCapture.h
//  better_audio_capture
//
//  Created by wangyang on 2022/5/11.
//

#import <Foundation/Foundation.h>

typedef void (^BetterAudioCaptureBlock)(NSData *data);

@interface BetterAudioCapture : NSObject

- (void)initWithSampleRate:(NSInteger)sampleRate channelCount:(NSInteger)channelCount;

- (void)startCaptureWithCallback:(BetterAudioCaptureBlock)callback;

- (void)stopCapture;

- (void)dispose;

@end
