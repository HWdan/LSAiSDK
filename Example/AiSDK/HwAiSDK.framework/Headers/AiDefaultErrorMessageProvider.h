//
//  AiDefaultErrorMessageProvider.h
//  AiSDK
//
//  Created by HuaWo on 2025/7/31.
//

#import <Foundation/Foundation.h>
#import "IAiErrorMessageProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface AiDefaultErrorMessageProvider : NSObject<IAiErrorMessageProvider>

@property(nonatomic, assign) NSInteger deviceLanguageCode;

@end

NS_ASSUME_NONNULL_END
