//
//  ThemeManager.h
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"
@interface ThemeManager : NSObject

//当前主题名
@property(nonatomic,copy)NSString *currentThemeName;
//所有可用主题
@property(nonatomic,copy)NSDictionary *allThemes;
//颜色字典
@property(nonatomic,copy)NSDictionary *colorConfigDic;

//获取单例类
+ (ThemeManager *)sharedManager;

//获取图片
- (UIImage *)themeImageWithName:(NSString *)imageName;

//获取颜色
- (UIColor *)themeColorWithName:(NSString *)colorName;

@end
