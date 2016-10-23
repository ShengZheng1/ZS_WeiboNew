//
//  SinaWeibo+SendWeibo.h
//  ZS_Weibo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SinaWeibo.h"

typedef void(^SendWeiboSuccessBlock)(id result);
typedef void(^SendWeiboFailBlock)(NSError *error) ;

@interface SinaWeibo (SendWeibo)


/*
 发送微博
 text  微博正文
 image 图片
 params 参数字典
 success 成功
 fail 失败
 */
- (void)sendWeiboWithText:(NSString *)text image:(UIImage *)image params:(NSDictionary *)params success:(SendWeiboSuccessBlock)success fail:(SendWeiboFailBlock)fail;

@end
