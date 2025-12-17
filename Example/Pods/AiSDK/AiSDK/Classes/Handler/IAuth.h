//
//  IAuth.h
//  Pods
//
//  Created by HuaWo on 2024/12/23.
//

#ifndef IAuth_h
#define IAuth_h
#import <Foundation/Foundation.h>
#import "AiDeviceInfo.h"

@protocol IAuth <NSObject>

- (AiDeviceInfo *) authInfo;
- (void) refreshToken;
- (BOOL) isExpired;
- (void) setLoginToken:(NSString *)accessToken;
- (void) refreshTokenComplete:(AiDeviceInfo *)authInfo
                         code:(int)code
                     errorMsg:(NSString *)errorMsg;

@end

#endif /* IAuth_h */
