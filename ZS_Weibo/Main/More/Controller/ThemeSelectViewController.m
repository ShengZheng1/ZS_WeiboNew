//
//  ThemeSelectViewController.m
//  ZS_Weibo
//
//  Created by apple on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ThemeSelectViewController.h"

@interface ThemeSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    UIColor *_textColor;
}

@end

@implementation ThemeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor clearColor];
    _table.dataSource = self;
    _table.delegate = self;
    
    //监听主题改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotificationName object:nil];
    
}

//主题改变
- (void)themeChanged{
    //获取字体颜色
    _textColor = [[ThemeManager sharedManager] themeColorWithName:kMoreItemTextColor];
    //刷新单元格
    [_table reloadData];
    
    //切换分割线颜色
    _table.separatorColor = [[ThemeManager sharedManager] themeColorWithName:kMoreItemLineColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [ThemeManager sharedManager].allThemes.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeManager *manager = [ThemeManager sharedManager];
    NSDictionary *allthemes = manager.allThemes;
    //获取所有主题的主题名
    NSArray *allNames = allthemes.allKeys;
    //创建单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //设置背景颜色
        cell.backgroundColor = [UIColor clearColor];
    }
    NSString *key = allNames[indexPath.row];
    cell.textLabel.text = key;
    //图片
    NSString *imageName = [NSString stringWithFormat:@"%@/%@",allthemes[key],@"more_icon_theme.png"];
    cell.imageView.image = [UIImage imageNamed:imageName];
    //刷新单元格颜色
    cell.textLabel.textColor = _textColor;
   
  
    //如果当前单元格，是被选中的单元格，则打钩
    if([key isEqualToString:manager.currentThemeName]){
        //打钩
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置当前显示的主题为点中的主题
    //获取所有的主题数组
    ThemeManager *manager = [ThemeManager sharedManager];
    NSDictionary *allThemes = manager.allThemes;
     NSArray *allNames = allThemes.allKeys;
    //从数组中拿到所对应的主题名字
    NSString *selectTheme = allNames[indexPath.row];
    //设定
    manager.currentThemeName = selectTheme;
    
    //刷新表视图
    [_table reloadData];
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
