//
//  ThemeLabel.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotificationName object:nil];
    }
    return self;
}
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotificationName object:nil];
}

//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//主题改变时
- (void)themeChanged
{
    //获取当前主题下的颜色
    UIColor *color = [[ThemeManager sharedManager]themeColorWithName:_colorName];
    //设置颜色
    self.textColor = color;
}

//刷新颜色
- (void)setColorName:(NSString *)colorName
{
    _colorName = [colorName copy];
    [self themeChanged];
}

@end
