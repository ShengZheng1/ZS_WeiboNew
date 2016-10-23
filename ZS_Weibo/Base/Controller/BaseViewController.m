//
//  BaseViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置主题背景
    //创建一个图片视图来实现背景图片切换
    ThemeImageView *imageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    imageView.imageName = @"bg_detail.jpg";
    [self.view insertSubview:imageView atIndex:0];
    
    [self createBackButton];
    
    // Do any additional setup after loading the view.
}

- (void)createBackButton{
    //判断导航控制器中是否有超过一个视图控制器
    if (self.navigationController.viewControllers.count >= 2 ) {
        ThemeButton *backButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 60, 44);
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        backButton.backgroundImageName = @"titlebar_button_back_9";
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    }
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
