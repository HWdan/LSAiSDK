//
//  DefaultTextToTranslateResultHandler.m
//  AiSDK
//
//  Created by HuaWo on 2025/3/25.
//

#import "DefaultTextToTranslateResultHandler.h"
#import "AiLogger.h"
#import "AiSDK/AiSDK.h"
#import <HwBluetoothSDK/HwBluetoothSDK.h>
#import "AiLocaleUtils.h"
//#import <NativeLib/NativeLib.h>
//#import <NativeLib/NativeLib-Swift.h>
@import NativeLib;

@interface DefaultTextToTranslateResultHandler()

@property(nonatomic, assign) BOOL isCanceled;
@property(nonatomic, copy) NSString *chatId;

@end

@implementation DefaultTextToTranslateResultHandler

- (void) getResultFromServer:(NSString *)text
{
    if (self.isCanceled) {
        [AiLogger i:@"TextToTranslate 已取消"];
        return;
    }
    
    NSString *requestId = [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])];
    NSString *wid = [[AiSDK sharedInstance] getDeviceInfo].Id;
    
    NSString *inputLanguagePrefix = [HwLanguageUtil getLocaleWithLanguage:self.inputLanguage];
    NSString *outputLanguagePrefix = [HwLanguageUtil getLocaleWithLanguage:self.outputLanguage];
    
    NSString *inputLocale = [AiLocaleUtils fitLocale:inputLanguagePrefix];
    NSString *outputLocale = [AiLocaleUtils fitLocale:outputLanguagePrefix];
    
    NSString *agentCode = @"CdTnaimjFJ1N7B5EbT";
    __weak typeof(self) weakSelf = self;
    [[AFlash shared] chatWithRequestId:requestId wid:wid thirdUuid:nil code:agentCode inputType:@"text" contentId:nil textContent:text data:nil fileFormat:nil inputLanguage:inputLocale outputLanguage:outputLocale onSuccess:^(NSString * _Nonnull requestId, NSString * _Nonnull sendTextContent, NSString * _Nonnull outputType, NSString * _Nonnull contentId, NSString * _Nullable answerTextContent, NSString * _Nullable imgUrl, NSString * _Nullable thumbnail, SubscriptionInfo * _Nullable subscriptionInfo) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf convertComplete:answerTextContent code:0 errorMsg:nil];
        }

    } onFailure:^(NSString * _Nonnull requestId, ErrorCode * _Nonnull errorCode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf convertComplete:nil code:[errorCode.code integerValue] errorMsg:[[AiSDK sharedInstance] errorMsgWithCode:[errorCode.code integerValue]]];
        }
    }];
}

- (void)cancel {
    self.isCanceled = YES;
}

- (void)convert:(nonnull NSString *)text {
    self.isCanceled = NO;
    [self getResultFromServer:text];
    [AiLogger i:@"开始翻译：%@", text];
}

- (void)convertComplete:(NSString *)text
                   code:(NSInteger)code
               errorMsg:(NSString *)errorMsg
{
    if (self.isCanceled) {
        [AiLogger i:@"TextToTranslate convertComplete 已取消"];
        return;
    }
    if (code != 0) {
        [AiLogger e:@"Text To translate Failed: %@, %@", @(code), errorMsg];
    } else {
        [AiLogger i:@"%@", text];
    }
    [[AiSDK sharedInstance] textToTranslateResultCompleted:text code:code msg:[[AiSDK sharedInstance] errorMsgWithCode:code]];
}

- (void)changeInputLanguage:(NSInteger)inputLanguage outputLanguage:(NSInteger)outputLanguage
{
    self.inputLanguage = inputLanguage;
    self.outputLanguage = outputLanguage;
}

@end
