//
//  WeiboCellLayout.h
//  ZS_Weibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CellTopViewHeight 60
#define SpaceWidth 10
#define ImageViewSpace 5
#define ImageViewWidth 200
#define LineSpace 3
@interface WeiboCellLayout : NSObject
//数据输入
@property(nonatomic,strong) WeiboModel *weibo;

+ (instancetype)layoutWithWeiboModel:(WeiboModel *)weibo;

//布局输出
@property(nonatomic,assign,readonly) CGRect weiboTextFrame;  //正文frame
//@property(nonatomic,assign,readonly) CGRect weiboImageViewFrame; //正文图片frame
@property(nonatomic,assign,readonly) CGRect reWeiboTextFrame; //转发微博文本frame
@property(nonatomic,assign,readonly) CGRect reWeiboBgImageViewFrame; //转发微博背景图片frame

//微博正文九个图片
@property(nonatomic,strong,readonly) NSArray *imageFrameArr;

//转发微博九个图片
@property(nonatomic,strong,readonly) NSArray *reImageFrameArr;

//总高度
- (CGFloat)cellHeight;



@end
