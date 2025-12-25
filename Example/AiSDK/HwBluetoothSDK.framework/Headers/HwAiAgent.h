//
//  HwAiAgent.h
//  HwBluetoothSDK
//
//  Created by HuaWo on 2025/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HwAiAgentType) {
    // 健康相关
    HwAiAgentTypeHealthyDietRecommendation = 0x80,
    HwAiAgentTypeExerciseHealthAssistant = 0x81,
    HwAiAgentTypeBloodSugarHealth = 0x82,
    HwAiAgentTypePsychologicalConsultant = 0x83,
    HwAiAgentTypePersonalChef = 0x84,
    HwAiAgentTypeTravelPlanningExpert = 0x85,
    HwAiAgentTypeFoodCalorieQuery = 0x86,
    HwAiAgentTypeRunningMethods = 0x87,
    
    // 文案创作
    HwAiAgentTypeCopywriterGenerator = 0x88,
    HwAiAgentTypePASSalesCopy = 0x8b,
    HwAiAgentTypeAdMadman = 0x8c,
    HwAiAgentTypeWeeklyReportGenerator = 0x8d,
    
    // 娱乐休闲
    HwAiAgentTypeAstrologer = 0x89,
    HwAiAgentTypeHoroscope = 0x8e,
    HwAiAgentTypeWhatToEatToday = 0x8f,
    HwAiAgentTypeRapper = 0x90,
    HwAiAgentTypeJokeTeller = 0x91,
    HwAiAgentTypeMockMaster = 0x92,
    HwAiAgentTypeAnswerBook = 0x93,
    
    // 生活服务
    HwAiAgentTypeColorCoordinator = 0x94,
    HwAiAgentTypeDreamInterpreter = 0x95,
    HwAiAgentTypeHealthExpert = 0x96,
    HwAiAgentTypeSkincareEncyclopedia = 0x97,
    HwAiAgentTypeLifeHacks = 0x98,
    HwAiAgentTypePetHealthConsultant = 0x99,
    HwAiAgentTypeTranslator = 0x9a,
    HwAiAgentTypeWeatherForecast = 0x9b,
    
    // 人际沟通
    HwAiAgentTypeHighEQReply = 0x9c,
    HwAiAgentTypeMBTIExpert = 0x9d,
    HwAiAgentTypeCareerPlanning = 0x9e,
    
    // 办公工具
    HwAiAgentTypeDataAnalysis = 0x9f,
    HwAiAgentTypePptMaker = 0xa0,
    HwAiAgentTypeMovieExplanation = 0xa1,
    HwAiAgentTypeCreativeGenerator = 0xa2,
    HwAiAgentTypeDailyQuote = 0xa3,
    HwAiAgentTypeAIBookReader = 0xa4,
    HwAiAgentTypeSWOTExpert = 0xa5,
    
    // 个人发展
    HwAiAgentTypeMemoryTraining = 0xa6,
    HwAiAgentTypeSleepManager = 0xa7,
    HwAiAgentTypePartyGames = 0xa8,
    HwAiAgentTypeGiftRecommendation = 0xa9,
    HwAiAgentTypeProgrammingGuide = 0xaa,
    
    // 知识百科
    HwAiAgentTypeFlowerLanguage = 0xab,
    HwAiAgentTypePersonalColorAnalysis = 0xac,
    HwAiAgentTypeHandcraftExpert = 0xad,
    HwAiAgentTypeParentingKnowledge = 0xae,
    HwAiAgentTypeWorldRecords = 0xaf,
    HwAiAgentTypeBookLibrary = 0xb0,
    HwAiAgentTypeCarHome = 0xb1,
    HwAiAgentTypeGeographyKnowledge = 0xb2,
    HwAiAgentTypeScienceSpace = 0xb3,
    
    // 技术工具
    HwAiAgentTypeAITextExpansion = 0xb4,
    HwAiAgentTypeIQTest = 0xb5,
    
    // 情感社交
    HwAiAgentTypeDatingTips = 0xb6,
    HwAiAgentTypeBrainTeasers = 0xb7,
    
    // 思维训练
    HwAiAgentTypeThinkingTraining = 0xb8,
    HwAiAgentTypeChatCompanion = 0xb9,
    HwAiAgentTypeProbabilityCalculation = 0xba,
    HwAiAgentTypeBMICalculator = 0x8a
};
@interface HwAiAgent : NSObject

@property(nonatomic, assign) HwAiAgentType type;
@property(nonatomic, assign) BOOL on;

@end

NS_ASSUME_NONNULL_END
