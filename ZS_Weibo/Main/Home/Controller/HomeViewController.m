//
//  HomeViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeImageView.h"
#import "WeiboModel.h"
#import "YYModel.h"
#import "UserModel.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"
#import "WXRefresh.h"
#import <AVFoundation/AVFoundation.h>
//获取首页微博接口
#define kGetTimeLineWeiboAPI @"statuses/home_timeline.json"
@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSMutableArray *_weiboArray;
    ThemeImageView *_newWeiboCountView;
    UILabel *_newWeiboCountLabel;
    //提示音ID
    SystemSoundID _msgComeID;
}



@end

@implementation HomeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
   
    
    [self loadWeiboData];
    [self createTable];
    //获取声音文件路径
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"msgcome" withExtension:@"wav"];
    //注册系统声音
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileURL), &_msgComeID);
}

#pragma mark - 加载微博数据
- (void)loadWeiboData
{
    //发起网络请求
    //1获取微博对象
    SinaWeibo *weibo = kSinaWeiboObject;
    
    //2判断当前的登录状态是否有效
    if(![weibo isAuthValid])
    {
        [weibo logIn];
        return;
    }
    
    NSDictionary *params = @{@"count":@"20"};
    //3发起网络请求
    
  SinaWeiboRequest *request = [weibo requestWithURL:kGetTimeLineWeiboAPI //接口名
                   params:[params mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    //设置请求标记 100 ：第一次加载 101：下拉刷新 102：上拉加载
    request.tag = 100;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //注销系统声音
    AudioServicesRemoveSystemSoundCompletion(_msgComeID);
}

#pragma mark -网络请求完毕，接收到结果
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    //微博数组
    NSArray *array = result[@"statuses"];
    
    //接收返回的对象的数组
    NSMutableArray *mArray = [NSMutableArray array];
    //遍历数组
    for (NSDictionary *dic in array) {
        WeiboModel *weiboModel = [WeiboModel yy_modelWithJSON:dic];
        [mArray addObject:weiboModel];
        NSLog(@"%@ %@",weiboModel.user.name,weiboModel.text);
        
    }
    
    //判读状态
     if(request.tag  == 100)
     {
         //第一次加载
         _weiboArray = [mArray mutableCopy];
     }else if (request.tag == 101)
     {
         if (mArray.count == 0) {
             [_table.pullToRefreshView stopAnimating];
             [self showNewWeiboCount:0];
             return;
         }
         //下拉刷新
         //将mArray中的内容插入最前面
         NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, mArray.count)];
         [_weiboArray insertObjects:mArray atIndexes:indexSet];
         [_table.pullToRefreshView stopAnimating];
         //显示提示框
         [self showNewWeiboCount:mArray.count];
     }else{
         
     }
    
   
    
    [_table reloadData];
    
}

#pragma mark - 创建表视图
- (void)createTable{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"weiboCell"];
    
    //使用weak类型指针来解决block中的循环引用
    __weak HomeViewController *weakSelf = self;
    [_table addPullDownRefreshBlock:^{
        __strong HomeViewController *strongSelf = weakSelf;
        //下拉刷新
        [strongSelf loadNewData];
    }];
    
    //上拉加载更多
    [_table addInfiniteScrollingWithActionHandler:^{
        __strong HomeViewController *strongSelf = weakSelf;
        //上拉刷新
        [strongSelf loadMoreData];
    }];
    
    //创建新微博提示视图
    _newWeiboCountView = [[ThemeImageView alloc]initWithFrame:CGRectMake(3, 3, kScreenWidth - 6, 40)];
    _newWeiboCountView.imageName = @"timeline_notify" ;
    _newWeiboCountView.transform = CGAffineTransformMakeTranslation(0, -60);
    [self.view addSubview:_newWeiboCountView];
    //文本显示
    _newWeiboCountLabel = [[UILabel alloc]initWithFrame:_newWeiboCountView.bounds];
    _newWeiboCountLabel.text = @"1条微博";
    _newWeiboCountLabel.textAlignment = NSTextAlignmentCenter;
    [_newWeiboCountView addSubview:_newWeiboCountLabel];

}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _weiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weiboCell"];
    
    //填充微博数据
    WeiboModel *wb = _weiboArray[indexPath.row];
    
    [cell setWeibo:wb];
    
    
    
    
    return cell;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取微博对象
    WeiboModel *weibo = _weiboArray[indexPath.row];
//    NSDictionary *attributes = @{NSFontAttributeName:kWeiboTextFont};
//    CGRect rect = [weibo.text boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//    CGFloat height = rect.size.height;
//    
//    CGFloat imageHeight = weibo.bmiddle_pic ? 210 : 0;
//    
//    return height + 60 + 10 + 10 +imageHeight;
    
    //创建布局对象
    WeiboCellLayout *layout = [WeiboCellLayout layoutWithWeiboModel:weibo];
    
    return [layout cellHeight];
}

#pragma mark- 加载更多数据
- (void)loadNewData{
   //请求网络数据，获取比当前微博列表中，第一条微博更晚的微博
    WeiboModel *firstWeibo = [_weiboArray firstObject];
    //获取第一条微博的id
    NSString *idstr = firstWeibo.idstr;
    //发起网络请求
    //1获取微博对象
    SinaWeibo *weibo = kSinaWeiboObject;
    
    //2判断当前的登录状态是否有效
    if(![weibo isAuthValid])
    {
        [weibo logIn];
        return;
    }
    
    NSDictionary *params = @{@"since_id":idstr};
    //3发起网络请求
    
   SinaWeiboRequest *request =  [weibo requestWithURL:kGetTimeLineWeiboAPI //接口名
                   params:[params mutableCopy]
               httpMethod:@"GET"
                 delegate:self];
    request.tag = 101;
    
}

- (void)loadMoreData{
    NSLog(@"上拉加载 更多微博");
    [_table.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    
}

#pragma maek - 微博数量显示
- (void)showNewWeiboCount:(NSInteger)count{
    //设置文本显示条数
    if (count == 0) {
        _newWeiboCountLabel.text = @"没有新微博";
    }else{
        _newWeiboCountLabel.text = [NSString stringWithFormat:@"%li条新微博",count];
    }
    //播放动画效果
    [UIView animateWithDuration:0.5 animations:^{
        _newWeiboCountView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //播放提示音
        AudioServicesPlaySystemSound(_msgComeID);
        //延迟2秒 让文本视图消失
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _newWeiboCountView.transform = CGAffineTransformMakeTranslation(0, -60);
        } completion:nil];
    }];
    
}

#pragma mark - 刷新微博
- (void)reloadNewWeibo{
//    NSLog(@"刷新微博");
    //播放下拉刷新动画
    [_table.pullToRefreshView startAnimating];
    //调用下拉刷新方法
    [self loadNewData];
}

//- (IBAction)logOut:(UIButton *)sender {
//    //获取AppDelegate
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate logOutWeibo];
//}
//
//- (IBAction)login:(UIButton *)sender {
//    //执行登录操作
//    //获取微博对象
//    SinaWeibo *sinaWeibo =  ((AppDelegate *)[UIApplication sharedApplication].delegate).sinaWeibo;
//    
//    //登录
//    [sinaWeibo logIn];
//    
//    //OAuth 2.0认证
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
