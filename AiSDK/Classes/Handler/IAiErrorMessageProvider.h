//
//  IAuth.h
//  Pods
//
//  Created by HuaWo on 2024/12/23.
//

#ifndef IAiErrorMessageProvider_h
#define IAiErrorMessageProvider_h
#import <Foundation/Foundation.h>

@protocol IAiErrorMessageProvider <NSObject>

- (NSString *) messageForCode:(NSInteger)code;

@end

#endif /* IAiErrorMessageProvider_h */
