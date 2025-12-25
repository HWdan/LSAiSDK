//
//  AiSDK.h
//  AiSDK
//
//  Created by HuaWo on 2024/12/23.
//

#import <Foundation/Foundation.h>
#import "AiDeviceInfo.h"
#import "WatchfaceSDK/WatchfaceSDK-Swift.h"
#import "ILog.h"
#import "AiSDKCallback.h"
#import "IAiWatchfaceNameProvider.h"
#import "IAiErrorMessageProvider.h"
#import "AiOrderInfo.h"
#import "AiExerciseAnalyzeModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HwMeeting;
@class HwHealthAnalysisResult;
typedef NS_ENUM(NSInteger, AiStyle) {
    //水墨
    AiStyleInkWater = 1,
    //赛博朋克
    AiStyleCyberpunk = 2,
    //动漫
    AiStyleAnime = 3,
    //折纸风格
    AiStyleFolding = 4,
    //针织风格
    AiStyleKnitted = 5,
    //平面动画风格
    AiStyleFlatAnimation = 6,
    //3D卡通风格
    AiStyle3DCartoon = 7,
    //乐高风格
    AiStyleLego = 8,
    //铅笔画
    AiStylePencilDrawing = 9
};

typedef NS_ENUM(NSInteger, AiError) {
    AiErrorAnswerFailed = 80421,
    AiErrorRecordVoiceIsEmpty = 80002,
    AiErrorAgentNotExists = 80003,
    AiErrorMeetingSummaryEmpty = 80004,
    AiErrorMeetingParseJsonError = 80005,
    AiErrorHealthDataNull = 80006,
    AiErrorHealthAnalysisResultNull = 80007,
    AiErrorPhoneStorageFull = 80010,
    AiErrorRecordToTextEmpty = 80401,
    AiErrorScaleAndCropImageFailed = 80023,
    AiErrorImageToBinFailed = 80024,
    AiErrorMakeQjsWatchfaceFailed = 80027,
    AiErrorModelError = 80031,
    AiErrorDeviceInfoIsNull = 80051,
    /**
     * 语音识别语音为空
     */
    AiErrorVoiceToTextEmpty = 4,
    /**
     * 次数不足
     */
    AiErrorInsufficientFrequency = 8,
    /**
     * 当日免费次数不足
     */
    AiErrorDailyInsufficientFreeTimes = 9,
    /**
     * 免费次数用完
     */
    AiErrorInsufficientFreeTimes = 10,
    /**
     * 问答内容限制
     */
    AiErrorContentRestrictions = 12,
    /**
     * 语音输入不在手表语言列表内
     */
    AiErrorUnsupportedLanguages = 13,
    /**
     * 无法连接AFlash服务器
     */
    AiErrorCannotConnectToAFlash = 1102,
    /**
     * 无法访问AFlash服务器
     */
    AiErrorAFlashRequestTimeout = 1101,
    /**
     * 未知错误
     */
    AiErrorAFlashUnknownError = 1103,
    /**
     * AFlash内部服务器错误
     */
    AiErrorAFlashServerError = 50,
    /**
     * 域名配置不存在
     */
    AiErrorAFlashDomainError = 1,
    /**
     * 请求版本不匹配
     */
    AiErrorAFlashVersionError = 2,
    /**
     * 渠道配置不存在
     */
    AiErrorAFlashConfigError = 3,
    /**
     * 请求参数错误
     */
    AiErrorAFlashParamsError = 5,
    /**
     * 用户验证失败
     */
    AiErrorAFlashUserNotAuth = 61
};

@interface AiSDK : NSObject

+ (AiSDK *) sharedInstance;
/**
 绘制style
 */
@property(nonatomic, assign) AiStyle aiStyle;
@property(nonatomic, assign) BOOL isAiWatchfaceWorking;
@property(nonatomic, strong) id<AiSDKCallback> callback;

- (void) setDeviceInfo:(AiDeviceInfo *)deviceInfo;
- (AiDeviceInfo *) getDeviceInfo;
- (void) cleanDeviceInfo;

- (void) startWorking;
- (void) stopWorking;

/// ======  methods
- (void) voiceDialogStarted;
- (void) voiceToTextCompleted:(NSString *_Nullable)result
                         code:(NSInteger)code
                          msg:(NSString *_Nullable)msg;
- (void) textToAnswerCompleted:(NSString *_Nullable)result
                          code:(NSInteger)code
                           msg:(NSString *_Nullable)msg;
- (void) textToImageCompleted:(UIImage *_Nullable)image
                         code:(NSInteger)code
                          msg:(NSString *_Nullable)msg;
- (void) imageToPreviewCompleted:(UIImage *_Nullable)image
                            code:(NSInteger)code
                             msg:(NSString *_Nullable)msg;
- (void) previewSyncToDeviceCompleted:(NSInteger)code
                                  msg:(NSString *_Nullable)msg;
- (void) watchfaceSyncProgressUpdated:(CGFloat)progress;
- (void) watchfaceSyncToDeviceCompleted:(SlifiCustomWatchface *_Nullable)watchface
                                   code:(NSInteger)code
                                    msg:(NSString *_Nullable)msg;

- (void) textToAgentResultCompleted:(NSString *_Nullable)result
                               code:(NSInteger)code
                                msg:(NSString *_Nullable)msg;

- (void) textToTranslateResultCompleted:(NSString *_Nullable)result
                                   code:(NSInteger)code
                                    msg:(NSString *_Nullable)msg;
- (void) textToVoiceCompleted:(NSString *_Nullable)filePath
                         code:(NSInteger)code
                          msg:(NSString *_Nullable)msg;

- (void) meetingResultCompleted:(HwMeeting *_Nullable)meeting
                  voiceFilePath:(NSString *_Nullable)voiceFilePath
                    meetingTime:(NSDate *_Nullable)meetingTime
                            code:(NSInteger)code
                            msg:(NSString *_Nullable)msg;

- (void) healthAnalysisResultCompleted:(HwHealthAnalysisResult *_Nullable)result
                                  code:(NSInteger)code
                                   msg:(NSString *_Nullable)msg;

- (NSString *) errorMsgWithCode:(NSInteger)code;
- (void) setLogger:(id<ILog>)logger;

- (NSString *) generateAiWatchfaceName;
- (void) setAiWatchfaceNameProvider:(id<IAiWatchfaceNameProvider>)nameProvider;
- (void) setAiErrorMessageProvider:(id<IAiErrorMessageProvider>)messageProvider;

- (void) getOrderInfoWithMac:(NSString *)mac
                    callback:(void(^)(AiOrderInfo *orderInfo, NSString *_Nullable errorMsg))callback;

/*
 type:38.普通运动分析，39.骑行骑马分析，40.户外跑步分析，41.户外健走徒步，42.室内行走分析、跑步机、跑酷、室内跑步分析，43.登山分析，44.越野跑、定向越野分析，45.攀岩分析，46.跳绳分析，47.椭圆机分析，48.划船机分析，49.开放水域游泳分析，50.泳池游泳、自由泳、蛙泳、仰泳、蝶泳分析
 data:传入要分析的运动数据字典
 */

- (void) getAiExerciseAnalyzeWithType:(int)type
                                 data:(NSDictionary *)data
                             callback:(void(^)(AiExerciseAnalyzeModel *exerciseAnalyzeModel, NSString *_Nullable errorMsg))callback;

@end

NS_ASSUME_NONNULL_END
