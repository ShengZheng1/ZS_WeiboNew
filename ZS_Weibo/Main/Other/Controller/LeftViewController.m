//
//  LeftViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSArray *_dataArr;
    NSInteger _selectIndex;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   //初始化数据源
    _dataArr = @[@"无",@"滑动",@"滑动&缩放",@"3D旋转",@"视差滑动"];
    
    _selectIndex = 1;
    
    //创建一个图片视图来实现背景图片切换
    ThemeImageView *imageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    imageView.imageName = @"mask_bg.jpg";
    [self.view insertSubview:imageView atIndex:0];
    
    [self createTableView];
}
- (void)createTableView{
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor clearColor];
    _table.dataSource = self;
    _table.delegate = self;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _dataArr[indexPath.row];
    if (_selectIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
//单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex = indexPath.row;
    [_table reloadData];
    
    MMExampleDrawerVisualStateManager *manager = [MMExampleDrawerVisualStateManager sharedManager];
    //改变滑动样式
    manager.leftDrawerAnimationType = indexPath.row;
    manager.rightDrawerAnimationType = indexPath.row;
    
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
