//
//  LocationViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

#define kLocationNearbyAPI @"place/nearby/pois.json"

@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *_locationManager;
    NSArray *_locationArray;
    
    UITableView *_tableView;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"周边地点";
    [self startLocation];
    
    [self createTableView];
    
    
    // Do any additional setup after loading the view.
}

//开启定位服务
- (void)startLocation{
    //获取位置管理器
    _locationManager = [[CLLocationManager alloc]init];
    //在iOS8 之后，需要来设置定位的服务类型 始终/在程序运行时
    //NSLocationAlwaysUsageDescription或者NSLocationWhenInUseUsageDescription
    //将需要使用的类型添加到plist中，然后加上提示语
    
    //请求定位权限
    if(kSystemVersion >= 8.0){
        //请求在程序使用期间的定位权限
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //设定定位的精准度  精准度越高 好点越高
    //kCLLocationAccuracyBest;
    //kCLLocationAccuracyNearestTenMeters;
    //kCLLocationAccuracyHundredMeters;
    //kCLLocationAccuracyKilometer;
    //kCLLocationAccuracyThreeKilometers;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //设置代理获取结果
    _locationManager.delegate = self;
    //开启定位
    [_locationManager
     startUpdatingLocation];

    
}

#pragma mark -CLLocationManagerDelegate
//在获取到最新的位置信息时 调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    NSLog(@"%@",locations);
    //当获取到位置信息后，关闭定位
    [manager stopUpdatingLocation];
    
    //获取当前的经纬度
    CLLocation *location = [locations firstObject];
    //经度
    double lon = location.coordinate.longitude;
    //纬度
    double lat = location.coordinate.latitude;
    
    //获取当前位置附件的地理信息（地点）
    //地理位置反编码 将经纬度坐标信息 ->实际的地点名称
    //新浪微博的地理信息接口
    //发起网络请求，获取附近的地点信息
    SinaWeibo *wb = kSinaWeiboObject;
    NSDictionary *dic = @{@"long":[NSString stringWithFormat:@"%f",lon],@"lat":[NSString stringWithFormat:@"%f",lat]};
    [wb requestWithURL:kLocationNearbyAPI params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
    
}

//获取附近的地点信息
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
   
    //保存地点信息
    _locationArray = result[@"pois"];
    [_tableView reloadData];
}

#pragma mark - UITableView
- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _locationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    //填充数据
    NSDictionary *dic = _locationArray[indexPath.row];
    //地址名称
    cell.textLabel.text = dic[@"title"];
    //地址
    if (![dic[@"address"] isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = dic[@"address"];
    }else{
        cell.detailTextLabel.text = nil;
    }
    
    //图标
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    
    
    return cell;
}

- (void)addLocationResultBlock:(LocationResultBlock)block{
    _block = [block copy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击一个单元格时
    //回传被选中的地理信息
    if(_block){
        _block(_locationArray[indexPath.row]);
    }
    //关闭定位界面
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
