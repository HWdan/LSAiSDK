//
//  AiOrderInfo.h
//  AiSDK
//
//  Created by huawo01 on 2025/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AiOrderInfo : NSObject

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic) NSInteger orderStatus;
// 次数小于0的时候表示无限次
@property (nonatomic) NSInteger orderNum;
// 0 包月、1 季度、2 年
@property (nonatomic) NSInteger orderType;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic, copy) NSString *orderCurrency;

@end

NS_ASSUME_NONNULL_END
