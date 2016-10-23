//
//  WeiboCell.m
//  ZS_Weibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboCell.h"
#import "GDataXMLNode.h"
#import "WeiboCellLayout.h"
#import "WXLabel.h"
#import "RegexKitLite.h"
#import "WeiboWebViewController.h"
#import "WXPhotoBrowser.h"

@interface WeiboCell()<WXLabelDelegate,PhotoBrowerDelegate>
{
    
}

@end
@implementation WeiboCell

- (void)setWeibo:(WeiboModel *)weibo{
    _weibo = weibo;
    //设置头像
    UIImageView *imageView = [self.contentView viewWithTag:200];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.weibo.user.profile_image_url]];
    
    //设置用户名
    ThemeLabel *nameLabel = [self.contentView viewWithTag:201];
    nameLabel.colorName = kHomeUserNameTextColor;
    nameLabel.text = self.weibo.user.name;
    
    //设置时间 Tue May 31 17:46:55 +0800 2011
    ThemeLabel *timeLabel = [self.contentView viewWithTag:202];
    timeLabel.colorName = kHomeTimeLabelTextColor;
    //使用时间格式化符 来转化时间字符串 NSDate
    NSString *formatterString = @"E M d HH:mm:ss Z yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置时间格式
    formatter.dateFormat = formatterString;
    //设置语言类型/地区
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    //时间格式化
    NSDate *date = [formatter dateFromString:_weibo.created_at];
    
    //判断时间段
    //计算时间差
    NSTimeInterval second = -[date timeIntervalSinceNow];
    NSTimeInterval minute = second/60;
    NSTimeInterval hour = minute/60;
    NSTimeInterval day = hour/24;
    
    NSString *timeString = nil;
    
    if (second<60) {
        timeString = @"刚刚";
    }else if (minute<60)
    {
        timeString = [NSString stringWithFormat:@"%li分钟之前",(NSInteger)minute];
    }else if (hour<24)
    {
        timeString = [NSString stringWithFormat:@"%li小时之前",(NSInteger)hour];
    }else if (day<7){
        timeString = [NSString stringWithFormat:@"%li天之前",(NSInteger)day];
    }else{
        //具体时间
        [formatter setDateFormat:@"M月d日 HH:mm"];
        //设置当前所在地区
        [formatter setLocale:[NSLocale currentLocale]];
        //转化成字符串
        timeString = [formatter stringFromDate:date];
    }
    timeLabel.text = timeString;
    
    
    //设置来源
    ThemeLabel *sourceLabel = [self.contentView viewWithTag:203];
    sourceLabel.colorName = kHomeTimeLabelTextColor;
    //<a href="http://weibo.com" rel="nofollow">新浪微博</a>
//    if (_weibo.source.length != 0) {
//        NSArray *array1 = [_weibo.source componentsSeparatedByString:@">"];
//        NSString *subString = [array1 objectAtIndex:1];
//        NSArray *array2 = [subString componentsSeparatedByString:@"<"];
//        NSString *source = [array2 firstObject];
//        sourceLabel.text = [NSString stringWithFormat:@"来源：%@",source];
//        sourceLabel.hidden = NO;
//    }
//    else{
//        sourceLabel.hidden = YES;
//    }
    
    //使用XML来获取来源
    if(_weibo.source.length != 0){
        GDataXMLElement *element = [[GDataXMLElement alloc]initWithXMLString:_weibo.source error:nil];
        //直接读标签间的字符串
        NSString *source = element.stringValue;
        sourceLabel.text = [NSString stringWithFormat:@"来源：%@",source];
        sourceLabel.hidden = NO;
        
    }
    else{
        sourceLabel.hidden = YES;
    }
    
    //创建布局对象
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:_weibo];
    
    //微博正文
    self.weiboTextLabel.text = self.weibo.text;
    //文本自适应
    self.weiboTextLabel.frame = layout.weiboTextFrame;
    
    
    //微博图片
    if (_weibo.retweeted_status.pic_urls.count > 0) {
        for (int i = 0; i<9; i++) {
            //取出imageView
            UIImageView *imageView = self.reImagesArray[i];
            
            //设置frame
            NSValue *value = layout.reImageFrameArr[i];
            CGRect frame = [value CGRectValue];
            imageView.frame = frame;
            if (i < _weibo.retweeted_status.pic_urls.count) {
            //设置内容
            NSURL *url = [NSURL URLWithString:_weibo.retweeted_status.pic_urls[i][@"thumbnail_pic"]];
                
            [imageView sd_setImageWithURL:url];
            }

        }
        for (UIImageView *iv in _imagesArray) {
            iv.frame = CGRectZero;
        }
    }else if(_weibo.pic_urls.count >0){
        
        for (int i = 0; i<9; i++) {
            //取出imageView
            UIImageView *imageView = self.imagesArray[i];

            //设置frame
            NSValue *value = layout.imageFrameArr[i];
            CGRect frame = [value CGRectValue];
            imageView.frame = frame;
             if (i < _weibo.pic_urls.count) {
                //设置内容
                NSURL *url = [NSURL URLWithString:_weibo.pic_urls[i][@"thumbnail_pic"]];
               
                [imageView sd_setImageWithURL:url];
            
           
            }
           
        }
        for (UIImageView *iv in _reImagesArray) {
            iv.frame = CGRectZero;
        }
    }else{
        for (UIImageView *iv in _imagesArray) {
            iv.frame = CGRectZero;
        }
        for (UIImageView *iv in _reImagesArray) {
            iv.frame = CGRectZero;
        }
    }
    
    //转发微博正文
    self.reWeiboTextLabel.frame = layout.reWeiboTextFrame;
    self.reWeiboTextLabel.text = _weibo.retweeted_status.text;
  
    
    //转发微博背景
    self.reWeiboBgImageView.frame = layout.reWeiboBgImageViewFrame;
    
    
    
}

#pragma mark - 创建子视图
//懒加载
- (UILabel *)weiboTextLabel{
    if (_weiboTextLabel == nil) {
        //创建对象
        _weiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        //设置字体大小
        _weiboTextLabel.font = kWeiboTextFont;
        //设置字体颜色
//        _weiboTextLabel.colorName = kHomeWeiboTextColor;
//        //行数
//        _weiboTextLabel.numberOfLines = 0;
        //添加代理
        _weiboTextLabel.wxLabelDelegate = self;
        //设置行间距
        _weiboTextLabel.linespace = LineSpace;
        //添加视图
        [self.contentView addSubview:_weiboTextLabel];
    }
    return _weiboTextLabel;
}

//- (UIImageView *)weiboImageView{
//    if (_weiboImageView == nil) {
//        _weiboImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        [self.contentView addSubview:_weiboImageView];
//    }
//    
//    return _weiboImageView;
//}

//微博正文图片数组
- (NSArray *)imagesArray{
    if (_imagesArray == nil) {
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < 9 ;i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imageView.backgroundColor = [UIColor blueColor];
            [self.contentView addSubview:imageView];
            [mArray addObject:imageView];
            //给图片添加点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewAction:)];
            tap.numberOfTouchesRequired = 1;
            tap.numberOfTapsRequired =1;
            [imageView addGestureRecognizer:tap];
            //开启图片视图的用户事件
            imageView.userInteractionEnabled = YES;
            imageView.tag = 100 +i;
            
        }
        _imagesArray = [mArray copy];
        
    }
    
    return _imagesArray;
}
//转发微博
- (WXLabel *)reWeiboTextLabel{
    if (_reWeiboTextLabel == nil) {
        _reWeiboTextLabel= [[WXLabel alloc]initWithFrame:CGRectZero];
//        _reWeiboTextLabel.colorName = kHomeReWeiboTextColor;
        _reWeiboTextLabel.font = kReWeiboTextFont;
        _reWeiboTextLabel.numberOfLines = 0;
        _reWeiboTextLabel.wxLabelDelegate = self;
        _reWeiboTextLabel.linespace = LineSpace;
        [self.contentView addSubview:_reWeiboTextLabel];
        
    }
    return _reWeiboTextLabel;
}
//微博转发图片数组
- (NSArray *)reImagesArray{
    if (_reImagesArray == nil) {
        NSMutableArray *mArray = [[NSMutableArray alloc]init];
        for(int i = 0;i < 9 ;i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            [self.contentView addSubview:imageView];
            [mArray addObject:imageView];
            //给图片添加点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapReImageViewAction:)];
            tap.numberOfTouchesRequired = 1;
            tap.numberOfTapsRequired =1;
            [imageView addGestureRecognizer:tap];
            //开启图片视图的用户事件
            imageView.userInteractionEnabled = YES;
            imageView.tag = 200 +i;
            
        }
        _reImagesArray = [mArray copy];
        
    }
    
    return _reImagesArray;
    
}

- (ThemeImageView *)reWeiboBgImageView{
    if (_reWeiboBgImageView == nil) {
        _reWeiboBgImageView = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        _reWeiboBgImageView.imageName = @"timeline_rt_border_selected_9.png";
        //设置图片拉伸点
        _reWeiboBgImageView.topCapWidth = 20;
        _reWeiboBgImageView.leftCapWidth = 30;
        [self.contentView insertSubview:_reWeiboBgImageView atIndex:0];
    }
    return _reWeiboBgImageView;
}

#pragma mark - WXLabelDelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    return @"(#[^#]+#)|(http(s)?://([a-zA-Z0-9._?&=-]+(/)?)+)|(@[\\w-]{2,30})";
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    return [[ThemeManager sharedManager] themeColorWithName:kLinkColor];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor redColor];
}

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    
    //使用正则表达式判断所点击的是不是url链接
    NSString *regex = @"http(s)?://([a-zA-Z0-9._?&=-]+(/)?)+";
    if ([context isMatchedByRegex:regex]) {
        //创建浏览器界面
        WeiboWebViewController *webVC = [[WeiboWebViewController alloc]initWithURL:[NSURL URLWithString:context]];
        webVC.hidesBottomBarWhenPushed = NO;
        //使用响应者链查找导航控制器
        UIResponder *nextResponder = self.nextResponder;
        while (nextResponder) {
            //判断对象 是否是导航控制器
            if ([nextResponder isKindOfClass:[UINavigationController class]]) {
                //push跳转
                UINavigationController *navi = (UINavigationController *)nextResponder;
                [navi pushViewController:webVC animated:YES];
                break;
            }
            nextResponder = nextResponder.nextResponder;
        }
        
        
    }
}

#pragma mark ----
- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNotificationName object:nil];
    [self themeChange];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)themeChange{
    ThemeManager *manager = [ThemeManager sharedManager];
    self.weiboTextLabel.textColor = [manager themeColorWithName:kHomeWeiboTextColor];
    self.reWeiboTextLabel.textColor = [manager themeColorWithName:kHomeReWeiboTextColor];
}
#pragma mark - 图片点击
- (void)tapImageViewAction:(UITapGestureRecognizer *)tap{
    //获取被点击的图片
    UIImageView *imageView = (UIImageView *)tap.view;
    //显示图片浏览器
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:imageView.tag-100 delegate:self];
}

- (void)tapReImageViewAction:(UITapGestureRecognizer *)tap{
    //获取被点击的图片
    UIImageView *imageView = (UIImageView *)tap.view;
    //显示图片浏览器
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:imageView.tag-200 delegate:self];
}


#pragma mark - PhotoBrowerDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    
    if (_weibo.retweeted_status.pic_urls.count >0) {
        //转发微博中的图片
    
        return _weibo.retweeted_status.pic_urls.count;
    }
    else{
        //原微博中的图片
        return _weibo.pic_urls.count;
    }
}

//返回需要显示的图片对应的Photo实例，通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    //创建Photo对象
    WXPhoto *photo = [[WXPhoto alloc]init];
    
    NSString *imageUrlString = nil;
    
    if (_weibo.retweeted_status.pic_urls.count >0) {
        //转发微博中的图片
        NSDictionary *dic = _weibo.retweeted_status.pic_urls[index];
        imageUrlString = dic[@"thumbnail_pic"];
        
    }
    else{
        //原微博中的图片
        NSDictionary *dic = _weibo.pic_urls[index];
        imageUrlString = dic[@"thumbnail_pic"];
        
    }
    
    //缩略图地址http://ww2.sinaimg.cn/thumbnail/473dc7d6jw1f8n4mdsdmdj20qo0f3aar.jpg
    //将缩略图地址转化为大图地址
    imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    
    photo.url = [NSURL URLWithString:imageUrlString];
    
    if (_weibo.retweeted_status.pic_urls.count >0) {
        photo.srcImageView = _reImagesArray[index];
        
    }
    else{
        //原ImageView 获取ImageView的frame 来实现动画效果以及Imageview中的缩略图
        photo.srcImageView = _imagesArray[index];
        
    }

    
    
    
    
    return photo;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
