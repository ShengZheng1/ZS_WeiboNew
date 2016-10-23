//
//  WeiboAnnotation.m
//  ZS_Weibo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

- (void)setWeibo:(WeiboModel *)weibo{
    _weibo = weibo;
    
    //从微博对象中，获取地理位置信息，填充到coordinate中
    NSDictionary *geo = _weibo.geo;
   //获取经纬度
    NSArray *coordinates = geo[@"coordinates"];
    if (coordinates.count == 2) {
        //纬度
        double lat = [[coordinates firstObject]doubleValue];
        //经度
        double lon = [[coordinates lastObject]doubleValue];
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
}

@end
