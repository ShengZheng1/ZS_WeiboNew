//
//  ThemeImageView.h
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

//图片名
@property(nonatomic,copy)NSString *imageName;
//用于拉伸的坐标参数
@property(nonatomic,assign) CGFloat leftCapWidth;
@property(nonatomic,assign) CGFloat topCapWidth;
@end
