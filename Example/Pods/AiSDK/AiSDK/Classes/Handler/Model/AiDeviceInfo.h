//
//  AuthModel.h
//  Pods
//
//  Created by HuaWo on 2024/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AiDeviceInfo : NSObject

@property(nonatomic, copy) NSString *Id;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *mac;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger width;
@property(nonatomic, assign) NSInteger height;
@property(nonatomic, assign) NSInteger cornerRadius;
@property(nonatomic, assign) NSInteger thumbnailWidth;
@property(nonatomic, assign) NSInteger thumbnailHeight;
@property(nonatomic, assign) NSInteger thumbnailCornerRadius;
@property(nonatomic, assign) BOOL needPreviewBorder;
@property(nonatomic, assign) NSInteger previewBorderWidth;
@property(nonatomic, strong) UIColor *previewBorderColor;
@property(nonatomic, copy) NSString *currentLocale;
@property(nonatomic, copy) NSArray<NSString *> *supportedLocales;

- (AiDeviceInfo *) init;
- (AiDeviceInfo *) initWithId:(NSString *)Id
                         type:(NSString *)type
                          mac:(NSString *)mac
                        width:(NSInteger)width
                       height:(NSInteger)height
                 cornerRadius:(NSInteger)cornerRadius
               thumbnailWidth:(NSInteger)thumbnailWidth
              thumbnailHeight:(NSInteger)thumbnailHeight
        thumbnailCornerRadius:(NSInteger)thumbnailCornerRadius
                currentLocale:(NSString *)currentLocale;

@end

NS_ASSUME_NONNULL_END
