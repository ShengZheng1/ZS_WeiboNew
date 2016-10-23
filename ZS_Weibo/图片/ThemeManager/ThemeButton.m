//
//  ThemeButton.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton
//监听通知
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotificationName object:nil];
    }
    return self;
}

- (void)awakeFromNib{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotificationName object:nil];
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)themeChanged{
    //获取图片
    UIImage *image = [[ThemeManager sharedManager]themeImageWithName:_imageName];
    UIImage *bgImage = [[ThemeManager sharedManager]themeImageWithName:_backgroundImageName];
    //更新图片
    [self setImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
}
//更改图片名
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self themeChanged];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    [self themeChanged];
    
}
@end
