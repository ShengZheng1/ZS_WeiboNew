//
//  LocationViewController.h
//  ZS_Weibo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^LocationResultBlock)(NSDictionary *result);

@interface LocationViewController : BaseViewController

@property(nonatomic,copy)LocationResultBlock block;

- (void)addLocationResultBlock:(LocationResultBlock)block;

@end
