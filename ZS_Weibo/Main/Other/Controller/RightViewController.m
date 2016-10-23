//
//  RightViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RightViewController.h"
#import "SendWeiboViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+MMDrawerController.h"


@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self createButtons];
    //创建一个图片视图来实现背景图片切换
    ThemeImageView *imageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    imageView.imageName = @"mask_bg.jpg";
    [self.view insertSubview:imageView atIndex:0];
}
- (void)createButtons{
    CGFloat buttonWidth = 50;
    CGFloat space = 15;
    for (int i = 0; i < 5; i++) {
        //计算frame
        CGRect frame = CGRectMake(space, i*(buttonWidth+space)+space, buttonWidth, buttonWidth);
        //创建按钮
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
       
        [self.view addSubview:button];
        
        //设置图片
        NSString *imageName = [NSString stringWithFormat:@"newbar_icon_%i",i+1];
        button.imageName = imageName;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        
    }
    
    //下方按钮
    //地图
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [mapButton setImage:[UIImage imageNamed:@"btn_map_location"] forState:UIControlStateNormal];
    [self.view addSubview:mapButton];
    
    //二维码
    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qrButton.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [qrButton setImage:[UIImage imageNamed:@"qr_btn"] forState:UIControlStateNormal];
    [self.view addSubview:qrButton];
    
    qrButton.bottom = kScreenHeight - 64 - space;
    mapButton.bottom = qrButton.top - space;
}

- (void)buttonAction:(UIButton *)btn{
    if (btn.tag == 100) {
        //发微博
        //创建发微博界面
        SendWeiboViewController *sendVc = [[SendWeiboViewController alloc]init];
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:sendVc];
        
        //模态视图弹出
        [self presentViewController:navi animated:YES completion:^{
            //获取MMDrawerController
            MMDrawerController *mmCrl = self.mm_drawerController;
            //关闭侧边栏
            [mmCrl closeDrawerAnimated:YES completion:nil];
            
        }];
    }
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
