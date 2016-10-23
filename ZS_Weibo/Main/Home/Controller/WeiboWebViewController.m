//
//  WeiboWebViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboWebViewController.h"

@interface WeiboWebViewController ()

@end

@implementation WeiboWebViewController

- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建WebView
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:web];
    
    //创建网络请求
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
    
    //加载网络数据
    [web loadRequest:request];
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
