#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AiSDK.h"
#import "AiSDKCallback.h"
#import "IAiErrorMessageProvider.h"
#import "IAiWatchfaceNameProvider.h"
#import "IAuth.h"
#import "IHealthAnalysisResultHandler.h"
#import "IImageToPreviewHandler.h"
#import "IImageToWatchfaceHandler.h"
#import "IInitSDK.h"
#import "IMeetingResultHandler.h"
#import "AiDefaultErrorMessageProvider.h"
#import "AiDefaultInitSDK.h"
#import "DefaultAiWatchfaceNameProvider.h"
#import "DefaultAuthHandler.h"
#import "DefaultHealthAnalysisResultHandler.h"
#import "DefaultImageToPreviewHandler.h"
#import "DefaultImageToWatchfaceHandler.h"
#import "DefaultMeetingResultHandler.h"
#import "DefaultTextToAgentResultHandler.h"
#import "DefaultTextToAnswerTextHandler.h"
#import "DefaultTextToImageHandler.h"
#import "DefaultTextToTranslateResultHandler.h"
#import "DefaultTextToVoiceHandler.h"
#import "DefaultVoiceToTextHandler.h"
#import "ITextToAgentResultHandler.h"
#import "ITextToAnswerTextHandler.h"
#import "ITextToImageHandler.h"
#import "ITextToTranslateResultHandler.h"
#import "ITextToVoiceHandler.h"
#import "IVoiceToText.h"
#import "AiAgentState.h"
#import "AiAnswerState.h"
#import "AiDeviceInfo.h"
#import "AiTranslateState.h"
#import "AiWatchfaceState.h"
#import "AiDefaultLogger.h"
#import "AiLogger.h"
#import "ILog.h"
#import "AiOrderInfo.h"
#import "AiTextToImageService.h"
#import "AiTimeoutService.h"
#import "AiVoiceToTextService.h"
#import "AiFileUtils.h"
#import "AiImageUtils.h"
#import "AiLocaleUtils.h"
#import "AiSpUtils.h"
#import "AiStringUtils.h"
#import "NSDictionary+Ai.h"

FOUNDATION_EXPORT double AiSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char AiSDKVersionString[];

