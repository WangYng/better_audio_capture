#import <Flutter/Flutter.h>
#import "BetterAudioCaptureApi.h"

@interface BetterAudioCapturePlugin : NSObject<BetterAudioCaptureApiDelegate>

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end
