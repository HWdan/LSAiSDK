//
//  LocaleUtils.m
//  AiSDK
//
//  Created by HuaWo on 2025/1/9.
//

#import "AiLocaleUtils.h"

@implementation AiLocaleUtils

+ (NSString *) fitLocale:(NSString *)lan
{
    if ([lan hasPrefix:@"zh"]) {
        if ([lan hasPrefix:@"zh-Hant"]) {
            return @"zh-TW";
        } else {
            return @"zh-CN";
        }
    } else if ([lan hasPrefix:@"en"]) {
        return @"en-US";
    } else if ([lan hasPrefix:@"de"]) {
        return @"de-DE";
    } else if ([lan hasPrefix:@"es"]) {
        return @"es-ES";
    } else if ([lan hasPrefix:@"fr"]) {
        return @"fr-FR";
    } else if ([lan hasPrefix:@"it"]) {
        return @"it-IT";
    } else if ([lan hasPrefix:@"hi"]) {
        return @"hi-IN";
    } else if ([lan hasPrefix:@"pl"]) {
        return @"pl-PL";
    } else if ([lan hasPrefix:@"ru"]) {
        return @"ru-RU";
    } else if ([lan hasPrefix:@"cs"]) {
        return @"cs-CZ";
    } else if ([lan hasPrefix:@"vi"]) {
        return @"vi-VN";
    } else if ([lan hasPrefix:@"id"]) {
        return @"id-ID";
    } else if ([lan hasPrefix:@"tr"]) {
        return @"tr-TR";
    } else if ([lan hasPrefix:@"pt"]) {
        return @"pt-PT";
    } else if ([lan hasPrefix:@"th"]) {
        return @"th-TH";
    } else if ([lan hasPrefix:@"ar"]) {
        return @"ar-AE";
    } else if ([lan hasPrefix:@"bn"]) {
        return @"bn-IN";
    } else if ([lan hasPrefix:@"he"]) {
        return @"he-IL";
    } else if ([lan hasPrefix:@"km"]) {
        return @"km-KH";
    } else if ([lan hasPrefix:@"fa"]) {
        return @"fa-IR";
    } else if ([lan hasPrefix:@"ja"]) {
        return @"ja-JP";
    } else if ([lan hasPrefix:@"ms"]) {
        return @"ms-MY";
    } else if ([lan hasPrefix:@"uk"]) {
        return @"uk-UA";
    } else if ([lan hasPrefix:@"nl"]) {
        return @"nl-NL";
    } else if ([lan hasPrefix:@"ko"]) {
        return @"ko-KR";
    } else {
        return @"en-US";
    }
}

@end
