//
//  AiExerciseAnalyzeModel.h
//  AiSDK
//
//  Created by huawo01 on 2025/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AiExerciseAnalyzeModel : NSObject

@property (nonatomic, copy) NSString *trainingHighlights;
@property (nonatomic, copy) NSString *exerciseDurationAnalysis;
@property (nonatomic, copy) NSString *calorieConsumptionAnalysis;
@property (nonatomic, copy) NSString *heartRateAnalysis;//心率分析
@property (nonatomic, copy) NSString *trainingEffectAnalysis;//有氧、无氧训练效果分析
@property (nonatomic, copy) NSString *recoveryTimeAnalysis;//恢复时间分析
@property (nonatomic, copy) NSString *summarySuggestions;//总结与建议

@end

NS_ASSUME_NONNULL_END
