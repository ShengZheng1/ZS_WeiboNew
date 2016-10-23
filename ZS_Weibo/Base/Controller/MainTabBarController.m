//
//  MainTabBarController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

#pragma mark - 初始化
- (instancetype)init{
    if (self = [super init]) {
        [self createSubViewController];
        [self customTabBar];
    }
    return self;
}

//创建子控制器
- (void)createSubViewController{
    //读取五个故事版，获取视图控制器
    NSArray *storyboardNames = @[@"Home",@"Message",@"Discover",@"Profile",@"More"];
    
    NSMutableArray *naviArr = [NSMutableArray array];
    //将读取到的视图控制器，添加到ViewControllers
    for (NSString *name in storyboardNames) {
        //读取故事板
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
        //获取导航控制器
        UINavigationController *navi = [storyboard instantiateInitialViewController];
        [naviArr addObject:navi];
    }
    
    self.viewControllers = naviArr;
    
}

//自定义标签栏按钮
- (void)customTabBar{
    //设置标签栏背景
    ThemeImageView *imageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, -5, kScreenWidth, 54)];
    imageView.imageName = @"mask_navbar.png";
    [self.tabBar insertSubview:imageView atIndex:0];
  
    
    //删除原有按钮
    //获取标签栏的子视图
    for (UIView *subView in self.tabBar.subviews) {
        //判读获取到的子视图，是否是标签栏上的按钮
        Class buttonClass = NSClassFromString(@"UITabBarButton");
        if([subView isKindOfClass:buttonClass]){
            [subView removeFromSuperview];
        }
    }
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width/5;
    
    //自定义添加按钮
    for(int i = 0;i < 5;i++)
    {
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        //计算frame
        CGRect frame = CGRectMake(buttonWidth*i, 0, buttonWidth, 49);
        button.frame = frame;
        //设置图片
        NSString *imageName = [NSString stringWithFormat:@"home_tab_icon_%i",i+1];
        button.imageName = imageName;
        [self.tabBar addSubview:button];
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
    }
    
    //标签栏的阴影
    self.tabBar.shadowImage = [[UIImage alloc]init];
    //创建遮罩视图
    if (_arrowImageView == nil) {
        _arrowImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, 49)];
        _arrowImageView.imageName = @"home_bottom_tab_arrow";
        [self.tabBar addSubview:_arrowImageView];
    }
}

- (void)tabBarButtonAction:(UIButton*)btn{
    
    self.selectedIndex = btn.tag - 100;
    [UIView animateWithDuration:0.2 animations:^{
        _arrowImageView.center = btn.center;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
