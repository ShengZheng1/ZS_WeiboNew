//
//  ThemeManager.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ThemeManager.h"

#define kCurrentThemeNameKey @"kCurrentThemeNameKey"

@implementation ThemeManager
//单例
+ (ThemeManager *)sharedManager{
    static ThemeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[super allocWithZone:nil]init];
            
        }
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedManager];
}

- (id)copy{
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        //读取本地文件中的主题名
        _currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentThemeNameKey];
        if(_currentThemeName == nil)
        {
            _currentThemeName = @"猫爷";
        }
        //加载主题配置列表
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        _allThemes = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        //加载颜色配置文件
        [self loadColorConfigFile];
    }
    return self;
}

#pragma mark - 主题改变
- (void)setCurrentThemeName:(NSString *)currentThemeName
{
    //如果输入的主题名，不是已有主题，则直接返回
    if (!_allThemes[currentThemeName]) {
        return;
    }
    if (![_currentThemeName isEqualToString:currentThemeName]) {
        _currentThemeName = [currentThemeName copy];
        
        //每当切换主题，来重新加载颜色文件
        [self loadColorConfigFile];
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kThemeChangeNotificationName object:nil];
        
        //储存主题名到本地文件
        [[NSUserDefaults standardUserDefaults]setObject:_currentThemeName forKey:kCurrentThemeNameKey];
    }
}

//获取图片
- (UIImage *)themeImageWithName:(NSString *)imageName{
    //拼接图片名
    NSString *name = [NSString stringWithFormat:@"%@/%@",_allThemes[_currentThemeName],imageName];
    //读取图片
    UIImage *image = [UIImage imageNamed:name];
    
    return image;
}

#pragma mark - 字体颜色
- (void)loadColorConfigFile{
    //获取文件路径
    //获取程序文件包的根路径
    NSString *bundlePath = [[NSBundle mainBundle]resourcePath];

    //目标文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/config.plist",bundlePath,_allThemes[_currentThemeName]];
    //加载文件
    _colorConfigDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
}
//获取某一种特定的颜色
- (UIColor *)themeColorWithName:(NSString *)colorName
{
    //查询配置文件字典，获取具体颜色
    NSDictionary *colorDic = _colorConfigDic[colorName];
    if (colorDic == nil) {
        //未能找到相对应的颜色，默认使用黑色
        return [UIColor blackColor];
    }
    //创建UIColor
    CGFloat red = [colorDic[@"R"] doubleValue];
    CGFloat green = [colorDic[@"G"] doubleValue];
    CGFloat blue = [colorDic[@"B"] doubleValue];
    UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    
    return color;
}
@end
