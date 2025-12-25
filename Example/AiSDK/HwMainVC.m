//
//  HwMainVC.m
//  AiSDK_Example
//
//  Created by HuaWo on 2025/1/9.
//  Copyright © 2025 hulala1210. All rights reserved.
//

#import "HwMainVC.h"
#import "AiSDK_Example-Swift.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HwBluetoothSDK/HwBluetoothSDK.h"
#import "HwAiSDK/AiSDK.h"
#import "HwAiSDK/AiImageUtils.h"

@interface HwMainVC ()<ConnectVCDelegate, UITableViewDataSource, UITableViewDelegate, ILog, AiSDKCallback, IAiErrorMessageProvider>

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *macLbl;

@property (weak, nonatomic) IBOutlet UITextField *widthEt;
@property (weak, nonatomic) IBOutlet UITextField *heightEt;
@property (weak, nonatomic) IBOutlet UITextField *cornerRadiusEt;

@property (weak, nonatomic) IBOutlet UITextField *thumbnailWidthEt;
@property (weak, nonatomic) IBOutlet UITextField *thumbnailHeightEt;
@property (weak, nonatomic) IBOutlet UITextField *thumbnailCornerRadiusEt;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@property (weak, nonatomic) IBOutlet UITableView *logView;
@property (weak, nonatomic) IBOutlet UISwitch *dmSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *qbSwitch;

@property(nonatomic, strong) AiDeviceInfo *deviceInfo;
@property(nonatomic, strong) NSMutableArray *logLines;
@property(nonatomic, strong) SlifiCustomWatchface *watchface;

@end

@implementation HwMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = @"AI测试";
    // ====== 使用开始 =====
    // 需要实现代理方法
    [[AiSDK sharedInstance] setLogger:self];
    [[AiSDK sharedInstance] setAiErrorMessageProvider:self];
    // 需要实现代理方法
    [AiSDK sharedInstance].callback = self;
    // 开始工作
    [[AiSDK sharedInstance] startWorking];
    // ======= 使用结束 ======
    
    self.logLines = [NSMutableArray array];
    
    self.deviceInfo = [[AiDeviceInfo alloc] init];
    self.logView.backgroundColor = [UIColor blackColor];
//    self.logView.scrollEnabled = NO;
    self.logView.dataSource = self;
    self.logView.delegate = self;
    self.logView.allowsSelection = NO;
    [self.logView registerNib:[UINib nibWithNibName:@"LogCell" bundle:nil] forCellReuseIdentifier:[LogCell ID]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *wid = [userDefaults stringForKey:@"wid"];
    NSString *mac = [userDefaults stringForKey:@"mac"];
    NSString *name = [userDefaults stringForKey:@"name"];
    NSInteger width = [userDefaults integerForKey:@"width"];
    NSInteger height = [userDefaults integerForKey:@"height"];
    NSInteger cornerRadius = [userDefaults integerForKey:@"cornerRadius"];
    
    NSInteger thumbnailWidth = [userDefaults integerForKey:@"thumbnailWidth"];
    NSInteger thumbnailHeight = [userDefaults integerForKey:@"thumbnailHeight"];
    NSInteger thumbnailCornerRadius = [userDefaults integerForKey:@"thumbnailCornerRadius"];
    
    self.deviceInfo.Id = wid;
    self.deviceInfo.mac = mac;
    self.deviceInfo.name = name;
    self.deviceInfo.width = (width > 0) ? width : 480;
    self.deviceInfo.height = (height > 0) ? height : 480;
    self.deviceInfo.cornerRadius = (cornerRadius > 0) ? cornerRadius : 240;
    self.deviceInfo.thumbnailWidth = (thumbnailWidth > 0) ? thumbnailWidth : 264;
    self.deviceInfo.thumbnailHeight = (thumbnailHeight > 0) ? thumbnailHeight : 264;
    self.deviceInfo.thumbnailCornerRadius = (thumbnailCornerRadius > 0) ? thumbnailCornerRadius : 132;
    self.deviceInfo.currentLocale = [NSLocale currentLocale].languageCode;
    
    self.nameLbl.text = self.deviceInfo.name;
    self.macLbl.text = self.deviceInfo.mac;
    self.widthEt.text = [NSString stringWithFormat:@"%@", @(self.deviceInfo.width)];
    self.heightEt.text = [NSString stringWithFormat:@"%@", @(self.deviceInfo.height)];
    self.cornerRadiusEt.text = [NSString stringWithFormat:@"%@", @(self.deviceInfo.cornerRadius)];
    self.thumbnailWidthEt.text = [NSString stringWithFormat:@"%@", @(self.deviceInfo.thumbnailWidth)];
    self.thumbnailHeightEt.text = [NSString stringWithFormat:@"%@", @(self.deviceInfo.thumbnailHeight)];
    self.thumbnailCornerRadiusEt.text = [NSString stringWithFormat:@"%@", @(self.deviceInfo.thumbnailCornerRadius)];
    
    if (wid == nil || [@"" isEqualToString:wid]) {
        [self getDeviceId];
        return;
    } else {
        if (mac != nil || mac.length > 0) {
            [self connectWithMac:mac];
        }
    }
    
    [[AiSDK sharedInstance] setDeviceInfo:self.deviceInfo];
    
    if ([AiSDK sharedInstance].aiStyle == AiStyleAnime) {
        self.dmSwitch.on = YES;
        self.qbSwitch.on = NO;
    } else {
        self.dmSwitch.on = NO;
        self.qbSwitch.on = YES;
    }
}

- (void) connectWithMac:(NSString *)mac
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"连接手表"];
        [[HwBluetoothSDK sharedInstance] connectWithMac:mac callback:^(NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                return;
            }
            [SVProgressHUD showSuccessWithStatus:@"连接成功"];
            [SVProgressHUD dismissWithDelay:2];
            HwBluetoothDevice *device = [HwBluetoothSDK sharedInstance].connectedDevice;
            if (device) {
                [self didConnectWithDevice:device];
            }
        }];
    });
}

- (void) getDeviceId
{
    HwBluetoothDevice *device = [HwBluetoothSDK sharedInstance].connectedDevice;
    if (device == nil) {
        if (self.deviceInfo.mac.length > 0) {
            [self connectWithMac:self.deviceInfo.mac];
        }
        return;
    }
    
    [SVProgressHUD showWithStatus:@"获取设备ID"];
    [[HwBluetoothSDK sharedInstance] getDeviceIdWithCallback:^(NSString *str, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            return;
        }
        [SVProgressHUD dismissWithDelay:2];
        self.deviceInfo.Id = str;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:str forKey:@"wid"];
        [userDefaults setObject:self.deviceInfo.mac forKey:@"name"];
        [userDefaults setObject:self.deviceInfo.name forKey:@"mac"];
        [userDefaults synchronize];
        [[AiSDK sharedInstance] setDeviceInfo:self.deviceInfo];
    }];
}


- (IBAction)connectClick:(id)sender {
    ConnectVC *connectVC = [[ConnectVC alloc] init];
    connectVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:connectVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)setClick:(id)sender {
    if (self.deviceInfo.Id == nil || [@"" isEqualToString:self.deviceInfo.Id]) {
        [self getDeviceId];
        return;
    }
    
    self.deviceInfo.width = [self.widthEt.text integerValue];
    self.deviceInfo.height = [self.heightEt.text integerValue];
    self.deviceInfo.cornerRadius = [self.cornerRadiusEt.text integerValue];
    self.deviceInfo.thumbnailWidth = [self.thumbnailWidthEt.text integerValue];
    self.deviceInfo.thumbnailHeight = [self.thumbnailHeightEt.text integerValue];
    self.deviceInfo.thumbnailCornerRadius = [self.thumbnailCornerRadiusEt.text integerValue];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.deviceInfo.Id forKey:@"wid"];
    [userDefaults setObject:self.deviceInfo.mac forKey:@"mac"];
    [userDefaults setObject:self.deviceInfo.name forKey:@"name"];
    [userDefaults setObject:@(self.deviceInfo.width) forKey:@"width"];
    [userDefaults setObject:@(self.deviceInfo.height) forKey:@"height"];
    [userDefaults setObject:@(self.deviceInfo.cornerRadius) forKey:@"cornerRadius"];
    [userDefaults setObject:@(self.deviceInfo.thumbnailWidth) forKey:@"thumbnailWidth"];
    [userDefaults setObject:@(self.deviceInfo.thumbnailHeight) forKey:@"thumbnailHeight"];
    [userDefaults setObject:@(self.deviceInfo.thumbnailCornerRadius) forKey:@"thumbnailCornerRadius"];
    [userDefaults synchronize];
    
    [[AiSDK sharedInstance] setDeviceInfo:self.deviceInfo];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"girl" ofType:@"jpeg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    SlifiCustomWatchface *watchface = [[SlifiCustomWatchface alloc] initWithWidth:self.deviceInfo.width height:self.deviceInfo.height];
    watchface.name = [[AiSDK sharedInstance] generateAiWatchfaceName];
    watchface.name = @"TTTest";
    NSLog(@"name: %@", watchface.name);
    
    UIImage *bgImage = [AiImageUtils generateFitSizeImage:image width:self.deviceInfo.width height:self.deviceInfo.height];
    UIImage *preview = [AiImageUtils generateFitSizePreViewImage:image width:self.deviceInfo.width height:self.deviceInfo.height];
    
    bgImage = [AiImageUtils generateFitSizeRoundedImage:bgImage width:self.deviceInfo.width height:self.deviceInfo.height cornerRadius:self.deviceInfo.cornerRadius];
    preview = [AiImageUtils generateFitSizeRoundedImage:preview width:self.deviceInfo.thumbnailWidth height:self.deviceInfo.thumbnailHeight cornerRadius:self.deviceInfo.thumbnailCornerRadius];
    
    watchface.backgroundImage = bgImage;
    watchface.thumbnailImage = preview;
    
    QjsTimeWidget *time = [[QjsTimeWidget alloc] initWithTintColor:[UIColor whiteColor]];
    NSInteger timeX = (self.deviceInfo.width - time.width) / 2;
    NSInteger timeY = 60;
    time.x = timeX;
    time.y = timeY;
    
    NSInteger y = timeY + time.height + 10;
    QjsDateWidget *date = [[QjsDateWidget alloc] initWithTintColor:[UIColor whiteColor]];
    QjsWeekWidget *week = [[QjsWeekWidget alloc] initWithTintColor:[UIColor whiteColor]];
    
    NSInteger x = (self.deviceInfo.width - date.width - week.width - 4) / 2;
    date.x = x;
    date.y = y;
    
    x = date.x + date.width + 4;
    week.x = x;
    week.y = y;
    
    [watchface addWidget:time];
    [watchface addWidget:date];
    [watchface addWidget:week];
    
    self.watchface = watchface;
    
    HwBluetoothDevice *device = [HwBluetoothCenter sharedInstance].connectedDevice;
    NSString *deviceUUID = device.peripheral.identifier.UUIDString;
    [[SifliWatchfaceSDK getInstance] setCustomWatchfaceWithDevIdentifier:deviceUUID watchface:watchface compressSuccessCallback:^(BOOL success) {
        NSLog(@"compress succes: %@", @(success));
        } progressCallback:^(NSInteger progress) {
            NSLog(@"%@", @(progress));
        } finishCallback:^(BOOL success, NSString *message, NSInteger code, NSNumber *devCode) {
            NSLog(@"success: %@", @(success));
        }];
}

- (void)didConnectWithDevice:(HwBluetoothDevice *)device
{
    self.nameLbl.text = device.name;
    self.macLbl.text = device.macAddress;
    self.deviceInfo.name = device.name;
    self.deviceInfo.mac = device.macAddress;
    [self getDeviceId];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:[LogCell ID] forIndexPath:indexPath];
    [cell update:[self.logLines objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogLine *line = [self.logLines objectAtIndex:indexPath.row];
    return line.height;
}

- (IBAction)dmChanged:(id)sender {
    self.qbSwitch.on = !self.dmSwitch.on;
    if (self.dmSwitch.on) {
        [AiSDK sharedInstance].aiStyle = AiStyleAnime;
    } else {
        [AiSDK sharedInstance].aiStyle = AiStylePencilDrawing;
    }
}

- (IBAction)qbChanged:(id)sender {
    self.dmSwitch.on = !self.qbSwitch.on;
    if (self.dmSwitch.on) {
        [AiSDK sharedInstance].aiStyle = AiStyleAnime;
    } else {
        [AiSDK sharedInstance].aiStyle = AiStylePencilDrawing;
    }
}

- (void)d:(nonnull NSString *)msg {
    NSLog(@"QQQQ: %@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        LogLine *line = [[LogLine alloc] initWithMsg:msg level:0];
        [self.logLines addObject:line];
        [self.logView reloadData];
    });
}

- (void)e:(nonnull NSString *)msg {
    NSLog(@"QQQQ: %@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        LogLine *line = [[LogLine alloc] initWithMsg:msg level:3];
        [self.logLines addObject:line];
        [self.logView reloadData];
        [self scrollToBottom];
    });
}

- (void)i:(nonnull NSString *)msg {
    NSLog(@"QQQQ: %@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        LogLine *line = [[LogLine alloc] initWithMsg:msg level:1];
        [self.logLines addObject:line];
        [self.logView reloadData];
        [self scrollToBottom];
    });
}

- (void)w:(nonnull NSString *)msg {
    NSLog(@"QQQQ: %@", msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        LogLine *line = [[LogLine alloc] initWithMsg:msg level:2];
        [self.logLines addObject:line];
        [self.logView reloadData];
        [self scrollToBottom];
    });
}

- (void) scrollToBottom
{
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.logLines.count - 1 inSection:0];
    [self.logView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)aiImageDone:(UIImage *)image code:(NSInteger)code errorMsg:(NSString *)errorMsg
{
    self.resultImageView.image = image;
}

- (void)aiPreviewDone:(UIImage *)image code:(NSInteger)code errorMsg:(NSString *)errorMsg
{
    self.previewImageView.image = image;
}

- (void)aiSendingWatchfaceProgressUpdated:(float)progress
{
    NSInteger p = (NSInteger) (progress * 100);
    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"%@%%", @(p)]];
    // [SVProgressHUD showProgress:progress];
}

- (void) aiSentWatchface:(SlifiCustomWatchface *)watchface code:(NSInteger)code errorMsg:(NSString *)errorMsg
{
    if (code != 0) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"安装成功"];
    }
    
    [SVProgressHUD dismissWithDelay:2];
}

- (NSString *)messageForCode:(NSInteger)code
{
    if (code == 0) {
        return @"";
    }
    switch (code) {
        case AiErrorAnswerFailed:
            return @"AI回答失败";
        case AiErrorRecordVoiceIsEmpty:
            return @"录音文件为空";
        case AiErrorRecordToTextEmpty:
            return @"录音转文本，文本为空";
        case AiErrorScaleAndCropImageFailed:
            return @"压缩裁剪图片失败";
        case AiErrorImageToBinFailed:
            return @"转成bin失败";
        case AiErrorMakeQjsWatchfaceFailed:
            return @"制作qjs表盘失败";
        case AiErrorModelError:
            return @"AI模型错误";
        case AiErrorDeviceInfoIsNull:
            return @"设备信息为空，没有正常初始化SDK";
        case AiErrorVoiceToTextEmpty:
            return @"语音转文字结果为空";
        case AiErrorInsufficientFrequency:
            return @"没有次数了";
        case AiErrorDailyInsufficientFreeTimes:
            return @"今天没有免费次数了";
        case AiErrorInsufficientFreeTimes:
            return @"没有免费次数了";
        case AiErrorContentRestrictions:
            return @"有限制内容";
        case AiErrorUnsupportedLanguages:
            return @"不支持语种";
        case AiErrorCannotConnectToAFlash:
            return @"无法连接到艾闪";
        case AiErrorAFlashRequestTimeout:
            return @"艾闪请求超时";
        case AiErrorAFlashUnknownError:
            return @"艾闪服务器未知错误";
        case AiErrorAFlashServerError:
            return @"艾闪服务器错误";
        case AiErrorAFlashDomainError:
            return @"艾闪域名错误";
        case AiErrorAFlashVersionError:
            return @"艾闪版本不匹配错误";
        case AiErrorAFlashConfigError:
            return @"艾闪配置错误";
        case AiErrorAFlashParamsError:
            return @"艾闪参数错误";
        case AiErrorAFlashUserNotAuth:
            return @"艾闪用户未验证";
        default:
            break;
    }
    return @"Failed";
}

@end
