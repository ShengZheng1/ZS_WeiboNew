//
//  UserModel.m
//  ZS_Weibo
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)modelCustomPropertyMapper{
    //key model类中属性名字 value 字典中，属性对应的key
    return @{
             @"des" : @"description"
             };
}
@end
