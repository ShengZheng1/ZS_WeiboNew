//
//  BaseNavigationController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //监听通知，切换主题
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotificationName object:nil];
    
    
    
    //设置标题字体
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.titleTextAttributes = attributes;
    
    //将导航栏设置为不透明，会影响每一个视图的布局
    self.navigationBar.translucent = NO;
    [self themeChanged];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)themeChanged{
    //获取背景图片
    NSString *imageName;
    if (kSystemVersion >= 7) {
        imageName = @"mask_titlebar64";
    }
    else{
        imageName = @"mask_titlebar";
    }
    UIImage *image = [[ThemeManager sharedManager]themeImageWithName:imageName];
    //设置导航栏背景
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}
//设置状态栏字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
