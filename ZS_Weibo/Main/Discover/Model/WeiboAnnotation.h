//
//  WeiboAnnotation.h
//  ZS_Weibo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface WeiboAnnotation : NSObject<MKAnnotation>
//表示标注视图，在地图中显示的位置
//一般不会手动读取，而是在MapView中，自动读取这个属性来设置
@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;

//可选
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
//微博对象
@property(nonatomic,strong,nullable) WeiboModel *weibo;

@end
