//
//  IAuth.h
//  Pods
//
//  Created by HuaWo on 2024/12/23.
//

#ifndef IVoiceToText_h
#define IVoiceToText_h
#import <Foundation/Foundation.h>

@protocol IVoiceToText <NSObject>

- (void) prepare;
- (void) destroy;
- (void) startRecording:(NSInteger)language
                 aiType:(NSInteger)aiType;

- (void) stopRecording;
- (void) done:(NSString *)result
         code:(NSInteger)code
     errorMsg:(NSString *)errorMsg;
- (void) cancel;

@end

#endif /* IVoiceToText_h */
