//
//  WeiboModel.h
//  ZS_Weibo
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserModel;
@interface WeiboModel : NSObject

@property(nonatomic,copy) NSString *idstr; //微博编号
@property(nonatomic,copy) NSString *source; //微博来源
@property(nonatomic,copy) NSString *created_at;//微博创建时间
@property(nonatomic,copy) NSString *text;//微博信息内容
@property(nonatomic,copy) NSString *thumbnail_pic;//缩略图片地址
@property(nonatomic,copy) NSString *bmiddle_pic;//中等尺寸图片地址
@property(nonatomic,copy) NSString *original_pic;//原始图片地址
@property(nonatomic,copy) NSArray  *pic_urls; //多图地址
@property(nonatomic,strong) NSNumber *reposts_count;//转发数
@property(nonatomic,strong) NSNumber *comments_count;//评论数
@property(nonatomic,strong) NSNumber *attitudes_count;//表态数
@property(nonatomic,strong) UserModel *user;//	微博作者的用户信息字段
@property(nonatomic,strong) WeiboModel *retweeted_status;//	被转发的原微博信息字段
@property(nonatomic,copy) NSDictionary *geo; //位置信息



@end
