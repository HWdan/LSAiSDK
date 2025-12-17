//
//  AiSDKCallback.h
//  AiSDK
//
//  Created by HuaWo on 2025/1/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SlifiCustomWatchface;
@class HwMeeting;
@class HwHealthAnalysisResult;

@protocol AiSDKCallback <NSObject>

@optional
/**
 type: 0 表盘，1 问答
 */
- (void) aiStartRecording:(NSInteger)type;

- (void) aiStopRecording:(NSInteger)type;

- (void) aiVoiceToTextDone:(NSString *)text
                    type:(NSInteger)type;

- (void) aiAnswerDone:(NSString *_Nullable)answer
                 code:(NSInteger)code
             errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiTranslateDone:(NSString *_Nullable)result
                    code:(NSInteger)code
                errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiAgentDone:(NSString *_Nullable)result
                code:(NSInteger)code
            errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiMeetingDone:(HwMeeting *_Nullable)meeting
         voiceFilePath:(NSString *_Nullable)voiceFilePath
           meetingTime:(NSDate *_Nullable)meetingTime
                  code:(NSInteger)code
              errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiHealthAnalysisDone:(HwHealthAnalysisResult *_Nullable)result
                         code:(NSInteger)code
                     errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiImageDone:(UIImage *)image
                code:(NSInteger)code
            errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiPreviewDone:(UIImage *)image
                  code:(NSInteger)code
              errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiStartSendingPreview;

- (void) aiSentPreview:(NSInteger)code
              errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiStartSendingWatchface;

- (void) aiSendingWatchfaceProgressUpdated:(float)progress;

- (void) aiSentWatchface:(SlifiCustomWatchface *_Nullable)watchface
                    code:(NSInteger)code
                errorMsg:(NSString *_Nullable)errorMsg;

- (void) aiDidEnterTranslateWithInputLangugae:(NSInteger)inputLanguage
                               outputLanguage:(NSInteger)outputLanguage;
- (void) aiDidRequestAiTranslateResult;

@end

NS_ASSUME_NONNULL_END
