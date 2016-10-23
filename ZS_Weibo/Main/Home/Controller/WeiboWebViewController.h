//
//  WeiboWebViewController.h
//  ZS_Weibo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiboWebViewController : BaseViewController
@property(nonatomic,strong) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;
@end
