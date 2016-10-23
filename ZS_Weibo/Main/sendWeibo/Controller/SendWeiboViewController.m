//
//  SendWeiboViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "LocationViewController.h"
#import "SinaWeibo+SendWeibo.h"
#import "EmoticonInputView.h"

#define kSendWeiboAPI @"statuses/update.json"
#define kSendWeiboWithImageAPI @"statuses/upload.json"
#define kToolViewHeight  40
#define kLocationViewHeight 20


@interface SendWeiboViewController ()<SinaWeiboRequestDelegate>
{
    UITextView *_inputTextView; //输入框
    UIView *_toolView;    //工具视图
    
    //定位相关
    UIView *_locationView;
    UIImageView *_locationIconImageView;
    ThemeLabel *_locationNameLabel;
    ThemeButton *_locationCancelButton;
    
    //表情选中输入框
    EmoticonInputView *_emoticonView;
    
}

@property(nonatomic,strong)NSDictionary *locationData;

@end



@implementation SendWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写微博";
    //创建导航栏按钮
    [self createNavigationBarButton];
    //创建输入框
    [self createInputView];
    //创建工具栏
    [self createToolView];
    //创建位置视图
    [self createLocationViews];
    
    // Do any additional setup after loading the view.
}
- (void)createInputView{
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kToolViewHeight)];
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_inputTextView];
    
    //监听键盘的改变
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //键盘frame改变
    [center addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    //键盘隐藏
    [center addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark -键盘改变监听
- (void)keyboardFrameChanged:(NSNotification *)noti
{
    //获取键盘的状态
//    NSLog(@"%@",noti.userInfo);
    //键盘改变后的结束值
    NSValue *value = noti.userInfo[UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    
    //根据键盘的位置，来改变视图的位置
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight - keyboardFrame.size.height;
    //工具栏
    _toolView.top= _inputTextView.bottom;
    
    _locationView.bottom = _toolView.top;
}

- (void)keyboardHide:(NSNotification *)noti{
    //commond+K
//    NSLog(@"键盘隐藏%@",noti.userInfo);
    //根据键盘的位置，来改变视图的位置
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight;
    //工具栏
    _toolView.top= _inputTextView.bottom;
    
    _locationView.bottom = _toolView.top;
}

- (void)createToolView{
    _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolViewHeight)];
    _toolView.top = _inputTextView.bottom;
    _toolView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_toolView];
    //创建五个按钮
    NSArray *imageNames = @[@"compose_toolbar_1.png",
                            @"compose_toolbar_3.png",
                            @"compose_toolbar_4.png",
                            @"compose_toolbar_6.png",
                            @"compose_toolbar_5.png",
                            ];
    CGFloat buttonWidth = kScreenWidth/imageNames.count;
    for (int i = 0 ; i<5; i++) {
        CGRect frame = CGRectMake(i*buttonWidth, 0, buttonWidth, kToolViewHeight);
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.imageName = imageNames[i];
        [_toolView addSubview:button];
        button.tag = 100+i;
        [button addTarget:self action:@selector(toolBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
}

//commond + option +方向收代码
- (void)createNavigationBarButton{
    //titlebar_button_9.png
    //取消
    ThemeButton *leftButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.backgroundImageName = @"titlebar_button_9.png";
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //发送
    ThemeButton *rightButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 44);
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.backgroundImageName = @"titlebar_button_9.png";
    [rightButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createLocationViews{
    //创建父视图
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-10, kLocationViewHeight)];
    
    _locationView.bottom = _toolView.top;
    [self.view addSubview:_locationView];
    
    //icon
    _locationIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight)];
    [_locationView addSubview:_locationIconImageView];
    
    //label
    _locationNameLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(kLocationViewHeight, 0, 200, kLocationViewHeight)];
    _locationNameLabel.colorName = kMoreItemTextColor;
    _locationNameLabel.text = @"杭电生活区10南311";
    [_locationView addSubview:_locationNameLabel];
    
    //Button
    _locationCancelButton = [ThemeButton buttonWithType:UIButtonTypeCustom];
    _locationCancelButton.frame = CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight);
    _locationCancelButton.left = _locationNameLabel.right;
    _locationCancelButton.backgroundImageName = @"compose_toolbar_clear.png";
    [_locationCancelButton addTarget:self action:@selector(locationCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_locationView addSubview:_locationCancelButton];
    
    //默认隐藏
    _locationView.hidden = YES;
}

- (void)locationCancelButton
{
    self.locationData = nil;
}
#pragma mark - Action
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAction{
    
    //除去文本的空白字符
    NSString *text = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //判断输入框是否有文字
    if(_inputTextView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"没有输入微博正文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    //显示HUD
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithWindow:self.view.window];
    //添加HUD到window中
    [self.view.window addSubview:hud];
    //设置显示的文本
    hud.labelText = @"正在发送";
    //设置背景颜色，变暗效果
    hud.dimBackground = YES;
    //显示HUD
    [hud show:YES];
    
    //获取微博对象
    SinaWeibo *wb = kSinaWeiboObject;
    NSMutableDictionary *params = [@{@"status":text} mutableCopy];
    
    //判断当前是否有定位信息，如果有则添加
    if (self.locationData) {
        NSString *lon = self.locationData[@"lon"];
        NSString *lat = self.locationData[@"lat"];
        
        //添加数据
        [params setObject:lon forKey:@"lon"];
        [params setObject:lat forKey:@"lat"];
    }
    
//    [wb requestWithURL:kSendWeiboAPI params:params httpMethod:@"POST" delegate:self];
    [wb sendWeiboWithText:text image:nil params:params success:^(id result) {
        NSLog(@"发送成功");
        //收起键盘
        [_inputTextView resignFirstResponder];
        //返回前一页面
        [self dismissViewControllerAnimated:YES completion:^{
            //刷新微博
            UIApplication *app = [UIApplication sharedApplication];
            AppDelegate *deledate = (AppDelegate *)app.delegate;
            MMDrawerController *mm = (MMDrawerController *)deledate.window.rootViewController;
            MainTabBarController *tab = (MainTabBarController *)mm.centerViewController;
            BaseNavigationController *nav = (BaseNavigationController *)[tab.viewControllers firstObject];
            HomeViewController *home = (HomeViewController *)nav.topViewController;
            [home reloadNewWeibo];
            
            hud.labelText = @"发送成功";
            //隐藏HUD
            [hud hide:YES afterDelay:2];
            
        }];
   
                    
        
    } fail:^(NSError *error) {
        NSLog(@"失败");
        hud.labelText = @"发送失败";
        //隐藏HUD
        [hud hide:YES afterDelay:2];

    }];
    
}

//#pragma mark -SinaWeiboRequestDelegate
//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response{
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
////    NSLog(@"%li",httpResponse.statusCode);
//    if (httpResponse.statusCode == 200) {
//        NSLog(@"发送成功");
//        //收起键盘
//        [_inputTextView resignFirstResponder];
//        //返回前一页面
//        [self dismissViewControllerAnimated:YES completion:^{
//            //刷新微博
//            UIApplication *app = [UIApplication sharedApplication];
//            AppDelegate *deledate = (AppDelegate *)app.delegate;
//            MMDrawerController *mm = (MMDrawerController *)deledate.window.rootViewController;
//            MainTabBarController *tab = (MainTabBarController *)mm.centerViewController;
//            BaseNavigationController *nav = (BaseNavigationController *)[tab.viewControllers firstObject];
//            HomeViewController *home = (HomeViewController *)nav.topViewController;
//            [home reloadNewWeibo];
//            
//        }];
//    }
//}
#pragma mark - 工具栏按钮点击
- (void)toolBarButtonAction:(UIButton *)btn{
    if (btn.tag-100 == 4) {
        //打开定位界面
        LocationViewController *loc = [[LocationViewController alloc]init];
        //设置获取定位数据的Block回调
        [loc addLocationResultBlock:^(NSDictionary *result) {
            //保存位置数据
            self.locationData = result;
        }];
        [self.navigationController pushViewController:loc animated:YES];
    }else if (btn.tag - 100 == 3){
        //表情界面懒加载
        if (_emoticonView == nil) {
            _emoticonView = [[EmoticonInputView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
        //获取输入框，将输入视图设置为表情
        if (_inputTextView.inputView) {
            _inputTextView.inputView = nil;
        }
        else{
            _inputTextView.inputView = _emoticonView;
        }
        //重新加载输入视图
        [_inputTextView reloadInputViews];
        //强制弹出键盘
        [_inputTextView becomeFirstResponder];
        
    }
}

#pragma mark - 位置信息填充
//在locationData的set方法中来设置显示的位置数据
- (void)setLocationData:(NSDictionary *)locationData{
    if (_locationData != locationData) {
        _locationData = [locationData copy];
        if (_locationData == nil) {
            //点击取消按钮 将locationData设置为空
            _locationView.hidden = YES;
        }else{
            _locationView.hidden = NO;
        }
        //设置数据
        _locationNameLabel.text = _locationData[@"title"];
        [_locationIconImageView sd_setImageWithURL:[NSURL URLWithString:_locationData[@"icon"]]];
        
        //改变Label宽度
        NSDictionary *att = @{NSFontAttributeName:_locationNameLabel.font};
        CGRect rect = [_locationNameLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 10 - 2*kLocationViewHeight , kLocationViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
        CGFloat width = rect.size.width;
        _locationNameLabel.width =width;
        _locationCancelButton.left = _locationNameLabel.right;
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
