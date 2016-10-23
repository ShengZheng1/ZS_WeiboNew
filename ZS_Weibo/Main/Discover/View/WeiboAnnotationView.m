//
//  WeiboAnnotationView.m
//  ZS_Weibo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"

@implementation WeiboAnnotationView

//为了进行视图内容的自定义，需要覆写初始化方法
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return  self;
}

- (void)createSubviews{
    //背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
    bgImageView.image = [UIImage imageNamed:@"nearby_map_people_bg.png"];
    [self addSubview:bgImageView];
    //头像视图
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 50, 50)];
    userImageView.backgroundColor = [UIColor yellowColor];
    userImageView.layer.cornerRadius = 3;
    userImageView.layer.masksToBounds = YES;
    [bgImageView addSubview:userImageView];
    
    //改变背景视图位置，使背景视图底边中点对准左上角点
    //使底边中点位置为（0，0）
    bgImageView.frame = CGRectMake(-35, -70, 70, 70);
    
    //设置头像
    //获取标注对象
    WeiboAnnotation *annotation = self.annotation;
    //获取WeiboModel
    WeiboModel *model = annotation.weibo;
    //获取用户头像地址
    NSString *urlStr = model.user.profile_image_url;
    
    [userImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}
@end
