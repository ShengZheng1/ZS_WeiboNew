//
//  MoreViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet ThemeImageView *icon1;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon2;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon3;
@property (weak, nonatomic) IBOutlet ThemeImageView *icon4;
@property (weak, nonatomic) IBOutlet ThemeLabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *label1;
@property (weak, nonatomic) IBOutlet ThemeLabel *label2;
@property (weak, nonatomic) IBOutlet ThemeLabel *label3;
@property (weak, nonatomic) IBOutlet ThemeLabel *label4;
@property (weak, nonatomic) IBOutlet ThemeLabel *cacheLabel;

@end

@implementation MoreViewController
//界面即将显示
- (void)viewWillAppear:(BOOL)animated{
    ThemeManager *manager = [ThemeManager sharedManager];
    _themeNameLabel.text = manager.currentThemeName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ThemeImageView *imageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    imageView.imageName = @"bg_detail.jpg";
    [self.view insertSubview:imageView atIndex:0];
   
    _icon1.imageName = @"more_icon_theme.png";
    _icon2.imageName = @"more_icon_account.png";
    _icon3.imageName = @"more_icon_draft.png";
    _icon4.imageName = @"more_icon_feedback.png";
    
    //设置文本颜色
    _themeNameLabel.colorName = kMoreItemTextColor;
    _label1.colorName = kMoreItemTextColor;
    _label2.colorName = kMoreItemTextColor;
    _label3.colorName = kMoreItemTextColor;
    _label4.colorName = kMoreItemTextColor;
    _cacheLabel.colorName = kMoreItemTextColor;
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
