//
//  ImageConvertor.h
//  eZIPSDK
//
//  Created by Sifli on 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SFBoardType) {
    SFBoardType55X = 0,
    SFBoardType56X = 1,
    SFBoardType52X = 2,
    SFBoardType57X = 3,
    SFBoardType58X = 4
};
///2.4.1 EBinFromPngSequence 增加interval
///2.4.2 ezip_bin_type = 0时设置g_pal_support = 0
///2.4.3 支持apng
///2.4.4 支持arm64模拟器
///2.4.5 cocoapod发布打包为static library
///2.4.6 修复gif 处理不结束
///2.5.1 ezip 2026提速
///2.5.2 ezip winsize 2048
///2.5.3 增加setLvglVersion
///2.5.4增加gzip接口
///2.5.5 增加57x,58x支持
static NSString * const kSDKVersion = @"2.5.5";
@interface ImageConvertor : NSObject


///// png格式文件转为ezipBin类型。转换失败返回nil。
///// @param pngData png文件数据
///// @param eColor 颜色字符串
///// @param eType eizp类型
///// @param binType bin类型
//+(nullable NSData *)EBinFromPNGData:(NSData *)pngData eColor:(NSString *)eColor eType:(uint8_t)eType binType:(uint8_t)binType;


/// png格式文件转为ezipBin类型。转换失败返回nil。
/// @param pngData png文件数据 或者Gif数据
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板类型 @See SFBoardType
/// @return ezip or apng result, nil for fail
+(nullable NSData *)EBinFromPNGData:(NSData *)pngData
                             eColor:(NSString *)eColor
                              eType:(uint8_t)eType
                            binType:(uint8_t)binType
                          boardType:(SFBoardType)boardType;


/// pixel格式文件转为ezipBin类型。转换失败返回nil。
/// @param pixelData rgb565,rgb888
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板类型 @See SFBoardType 0:55x 1:56x  2:52x; 58x使用56x
/// @return ezip or apng result, nil for fail
//+(nullable NSData *)EBinFromPixelData:(NSData *)pixelData
//                               eColor:(NSString *)eColor
//                                eType:(uint8_t)eType
//                              binType:(uint8_t)binType
//                            boardType:(SFBoardType)boardType
//                                width:(NSInteger)width
//                               height:(NSInteger)height;


/// Nor 方案 将png格式文件序列转为ezipBin类型。转换失败返回nil。
/// @param pngDatas png文件数据序列
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板类型 @See SFBoardType
/// @param interval 序列帧间隔
/// @return ezip or apng result, nil for fail
+(nullable NSData *)EBinFromPngSequence:(NSArray<NSData *> *)pngDatas
                               eColor:(NSString *)eColor
                                eType:(uint8_t)eType
                              binType:(uint8_t)binType
                            boardType:(SFBoardType)boardType
                               interval:(uint32_t)interval;

/// 设置lvgl版本 7/8/9
/// @param lvglVersion 7/8/9
+(void)setLvglVersion:(uint8_t)lvglVersion;


/// GZip压缩
/// @param inData 输入数据
/// @return gzip data,nil for fail 没有header和length,不需要做偏移
+(nullable NSData *)gzipWithData:(NSData *)inData;
@end

NS_ASSUME_NONNULL_END
