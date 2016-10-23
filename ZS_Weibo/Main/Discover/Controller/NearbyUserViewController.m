//
//  NearbyUserViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NearbyUserViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "YYModel.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"

#define kNearbyWeiboAPI @"place/nearby_timeline.json"

//1创建地图显示视图
//2获取当前用户位置
//3将用户位置发送给服务器，获取附近的用户的微博
//显示在地图中

@interface NearbyUserViewController()<MKMapViewDelegate,SinaWeiboRequestDelegate>
{
    MKMapView *_mapView;
    BOOL _isLocation;
}
@end

@implementation NearbyUserViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self createMapView];
    _isLocation = NO;
    
    
}

- (void)createMapView{
    //在iOS8以上版本，需要获取定位权限
    if(kSystemVersion > 8.0)
    {
        //获取在应用程序使用期间 访问用户位置的权限
        [[[CLLocationManager alloc]init] requestWhenInUseAuthorization];
    }
    //创建地图视图
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    //显示当前用户位置
    //设置此属性为YES，地图会自动进行定位
    _mapView.showsUserLocation = YES;
    //获取用户位置 代理
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
}

//刷新了用户位置
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //调整地图显示的范围
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //获取经纬度
    double lat = coordinate.latitude;
    double lon = coordinate.longitude;
    
    //显示范围
    //地图显示的大小，单位为经纬度的1度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    //创建区域对象
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    //设定显示区域
    [_mapView setRegion:region animated:YES];
    
    //判断是否是第一次进行定位，只有在第一次定位时才来请求附近的微博
    if(_isLocation == NO){
        _isLocation = YES;
        
        //发送请求 获取附近的微博
        SinaWeibo *wb =kSinaWeiboObject;
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        //设置当前的位置信息
        [params setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
         [params setObject:[NSString stringWithFormat:@"%f",lon] forKey:@"long"];
        
        [wb requestWithURL:kNearbyWeiboAPI params:params httpMethod:@"GET" delegate:self];
    }
}

//获取附近微博信息
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    NSArray *arr = result[@"statuses"];
    //遍历数据 构造微博对象
    for (NSDictionary *dic in arr) {
        WeiboModel *weiboModel = [WeiboModel yy_modelWithDictionary:dic];
        //创建标注点
        WeiboAnnotation *annotation = [[WeiboAnnotation alloc]init];
        annotation.weibo = weiboModel;
        //在地图上添加标注点
        [_mapView addAnnotation:annotation];
        
    }
    
}

//自定义标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //当前用户位置点，也是一个标注视图
    //当前用户位置点不需要自定义标注，所以返回nil,让系统自己调用
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    //从复用池中获取标注视图
    WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"WeiboAnnotationView"];
    if (view == nil) {
        view = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"WeiboAnnotationView"];
    }
    
    return  view;
}


@end
