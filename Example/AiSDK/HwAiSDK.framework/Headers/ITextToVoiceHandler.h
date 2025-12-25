//
//  ITextToVoiceHandler.h
//  AiSDK
//
//  Created by HuaWo on 2025/3/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ITextToVoiceHandler <NSObject>

- (void) handle:(NSString *)text
           play:(BOOL)play;
- (BOOL) isHandling:(NSString *)text;
- (BOOL) isPlaying:(NSString *)text;
- (void) handle:(NSString *)text
          state:(NSInteger)state
       language:(NSInteger)language
         volumn:(NSInteger)volumn
            crc:(NSString *)crc;
- (void) cancel;
- (void) stop;

@end

NS_ASSUME_NONNULL_END
