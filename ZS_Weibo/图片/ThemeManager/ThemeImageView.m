//
//  ThemeImageView.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.leftCapWidth = 0;
        self.topCapWidth = 0;
        //监听主题改变的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationName object:nil];
    }
    return self;
}
//用storyboard创建的调用该方法
- (void)awakeFromNib{
    self.leftCapWidth = 0;
    self.topCapWidth = 0;
    //监听主题改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationName object:nil];
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    [self themeChange];
}

//主题改变时，刷新图片
- (void)themeChange{
    //获取当前视图，在当前主题下的图片
    
    //获取manager对象
    ThemeManager *manager = [ThemeManager sharedManager];
    
    //从管理器中，获取相对应得图片
    UIImage *image = [manager themeImageWithName:_imageName];
    
    
    //对图片进行拉伸处理
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];
    
    self.image = image;
}

//重新设置拉伸点时，刷新图片
- (void)setLeftCapWidth:(CGFloat)leftCapWidth{
    _leftCapWidth = leftCapWidth;
    [self themeChange];
}

- (void)setTopCapWidth:(CGFloat)topCapWidth
{
    _topCapWidth = topCapWidth;
    [self themeChange];
}
@end
