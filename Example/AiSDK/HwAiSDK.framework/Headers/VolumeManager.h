//
//  VolumeManager.h
//  AiSDK
//
//  Created by HuaWo on 2025/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VolumeManager : NSObject

+ (instancetype)sharedManager;

// 设置系统音量
- (void)setSystemVolume:(float)volume;

// 获取当前系统音量
- (float)getCurrentVolume;

@end

NS_ASSUME_NONNULL_END
