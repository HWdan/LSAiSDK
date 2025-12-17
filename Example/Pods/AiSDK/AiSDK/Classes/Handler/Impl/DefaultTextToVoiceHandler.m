//
//  DefaultTextToAgentResultHandler.m
//  AiSDK
//
//  Created by HuaWo on 2025/3/25.
//

#import "DefaultTextToVoiceHandler.h"
#import "AiLogger.h"
#import "AiSDK/AiSDK.h"
#import <HwBluetoothSDK/HwBluetoothSDK.h>
#import "AiFileUtils.h"
#import <AVFoundation/AVFoundation.h>
//#import <NativeLib/NativeLib.h>
//#import <NativeLib/NativeLib-Swift.h>
@import NativeLib;

@interface DefaultTextToVoiceHandler()<AVAudioPlayerDelegate>

@property(nonatomic, assign) BOOL isCanceled;
@property(nonatomic, copy) NSString *chatId;
@property(nonatomic, copy) NSString *cacheFilePath;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation DefaultTextToVoiceHandler

- (void)handle:(NSString *)text play:(BOOL)play
{
    [AiLogger i:@"text to voice: %@", text];
    NSString *requestId = [NSString stringWithFormat:@"%@", @([[NSDate date] timeIntervalSince1970])];
    NSString *wid = [[AiSDK sharedInstance] getDeviceInfo].Id;
    
    NSString *dir = [AiFileUtils generateTextToVoicePath];
    
    [AiLogger i:@"请求ID：%@, wid: %@, dir: %@", requestId, wid, dir];
    __weak typeof(self) weakSelf = self;
    [[AFlash shared] textToSpeechWithRequestId:requestId wid:wid thirdUuid:nil text:text fileFormat:@"mp3" onSuccess:^(NSString * _Nonnull requestId, NSData * _Nonnull data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSString *filePath = [strongSelf saveMP3Data:data toDirectory:dir withFixedFileName:@"record.mp3"];
            [strongSelf convertComplete:filePath code:0 errorMsg:nil];
        }
    } onFailure:^(NSString * _Nonnull requestId, ErrorCode * _Nonnull errorCode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf convertComplete:nil code:[errorCode.code integerValue] errorMsg:errorCode.message];

        }
    }];
}

#pragma mark - 保存data到本地下文件名record.mp3
- (NSString *)saveMP3Data:(NSData *)data toDirectory:(NSString *)directory withFixedFileName:(NSString *)fileName {
    if (!data || data.length == 0) {
        [AiLogger e:@"MP3数据为空，无法保存"];
        return nil;
    }
    
    if (!directory || directory.length == 0) {
        [AiLogger e:@"目录路径为空"];
        return nil;
    }
    
    if (!fileName || fileName.length == 0) {
        [AiLogger e:@"文件名为空"];
        return nil;
    }
    
    NSString *filePath = [directory stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;

    
    // 如果文件已存在，先删除旧文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL deleteSuccess = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!deleteSuccess) {
            [AiLogger e:@"删除旧文件失败: %@", error.localizedDescription];
            // 继续尝试写入，可能会覆盖
        }
    }
    
    // 保存文件
    BOOL success = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (!success) {
        [AiLogger e:@"保存MP3文件失败: %@", error.localizedDescription];
        return nil;
    }
    
    [AiLogger i:@"MP3文件保存成功: %@", filePath];
    return filePath;
}


- (void)cancel
{
    [self stop];
}

- (void)stop
{
    self.isCanceled = YES;
    [self stopPlaybackAndDeleteFile];
}

- (void)convertComplete:(NSString *)text
                   code:(NSInteger)code
               errorMsg:(NSString *)errorMsg
{
    if (self.isCanceled) {
        [AiLogger i:@"TextToVoice convertComplete 已取消"];
        return;
    }
    if (code != 0) {
        [AiLogger e:@"Text To Voice Failed: %@, %@", @(code), errorMsg];
        return;
    } else {
        [AiLogger i:@"mp3 file path: %@", text];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playAudioAtPath:text];
    });
}

- (void)playAudioAtPath:(NSString *)filePath {
    // 先停止当前播放并清理
    [self stopPlaybackAndDeleteFile];
    // 保存当前文件路径
    self.cacheFilePath = filePath;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [AiLogger e:@"文件不存在: %@", filePath];
        return;
    }
    
    NSError *error = nil;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    // 初始化音频播放器
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    self.audioPlayer.delegate = self;
    
    if (error) {
        [AiLogger e:@"初始化播放器失败: %@", error.localizedDescription];
        [self deleteAudioFile];
        return;
    }
    
    // 准备播放
    if ([self.audioPlayer prepareToPlay]) {
        [self.audioPlayer play];
        [AiLogger i:@"开始播放: %@", filePath];
    } else {
        [AiLogger e:@"准备播放失败，也继续播放：%@", filePath];
        [self.audioPlayer play];
        //[self deleteAudioFile];
    }
}

- (void)stopPlaybackAndDeleteFile {
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        [AiLogger i:@"播放已停止"];
    }
    [self deleteAudioFile];
}

- (void)deleteAudioFile {
    if (self.cacheFilePath) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.cacheFilePath]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.cacheFilePath error:&error];
            if (success) {
                [AiLogger i:@"文件已删除: %@", self.cacheFilePath];
            } else {
                [AiLogger i:@"删除文件失败: %@", error.localizedDescription];
            }
        }
        self.cacheFilePath = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [AiLogger i:@"播放完成"];
    [self deleteAudioFile];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [AiLogger e:@"解码错误: %@", error.localizedDescription];
    [self deleteAudioFile];
}



@end
