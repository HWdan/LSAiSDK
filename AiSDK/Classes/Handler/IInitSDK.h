//
//  IAuth.h
//  Pods
//
//  Created by HuaWo on 2024/12/23.
//

#ifndef IInitSDK_h
#define IInitSDK_h
#import <Foundation/Foundation.h>

@class AiDeviceInfo;
@protocol IInitSDK <NSObject>
- (void) initSDK:(AiDeviceInfo *)deviceInfo;
@end

#endif /* IInitSDK_h */
