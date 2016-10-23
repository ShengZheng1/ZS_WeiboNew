//
//  Emoticon.h
//  ZS_Weibo
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emoticon : NSObject

@property(nonatomic,copy) NSString *cht; //繁体文本
@property(nonatomic,copy) NSString *chs; //简体文本
@property(nonatomic,copy) NSString *gif;
@property(nonatomic,copy) NSString *png;
@property(nonatomic,copy) NSString *type;

@property(nonatomic,strong,readonly) UIImage *emoticonImage; // 表情所对应的图片

@end
