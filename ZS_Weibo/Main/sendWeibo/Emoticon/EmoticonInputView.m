//
//  EmoticonInputView.m
//  ZS_Weibo
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EmoticonInputView.h"
#import "YYModel.h"
#import "Emoticon.h"
#import "EmoticonView.h"
@implementation EmoticonInputView
- (instancetype)initWithFrame:(CGRect)frame{
    frame.size.height = kEmoticonInputViewHeight;
    //原点位置设置为0
    frame.origin = CGPointZero;
    self = [super initWithFrame:frame];
    if (self) {
       
        [self loadData];
        [self createScrollView];
        [self createPageView];
    }
    return self;
    
}

//读取表情数据
- (void)loadData{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
    NSMutableArray *mArray = [NSMutableArray array];
    //遍历和数据解析
    for (NSDictionary *dic in array) {
        Emoticon *emoticon = [Emoticon yy_modelWithDictionary:dic];
        [mArray addObject:emoticon];
    }
    
    _emoticonArray = [mArray copy];
    
}

//创建滑动视图
- (void)createScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrollViewHeight)];
    [self addSubview:_scrollView];
    
    //设置滑动视图
    //分页滑动
    _scrollView.userInteractionEnabled = YES;
    _scrollView.pagingEnabled = YES;
    //隐藏滑动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    //分配表情
    //总页数
    NSInteger pageCount = (_emoticonArray.count - 1)/32 +1;
    NSLog(@"%li",pageCount);
    for (int i = 0 ;i < pageCount; i++) {
        EmoticonView *emoticonView = [[EmoticonView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScrollViewHeight)];
        //表情数组分割
        NSRange range = NSMakeRange(32*i, 32);
        //判断是否超出范围
        if (range.location +range.length >_emoticonArray.count) {
            //调整分割的长度
            range.length = _emoticonArray.count - range.location;
        }
        NSArray *subArray = [_emoticonArray subarrayWithRange:range];
        
        
        //设置每一页所显示的表情
        emoticonView.emoticonsArray = subArray;
        
        [_scrollView addSubview:emoticonView];
    }
    
    //设置滑动范围
    _scrollView.contentSize = CGSizeMake(pageCount*kScreenWidth, 0);
    
    _scrollView.delegate = self;
}

//滑动视图滑动后改变 pageContrl的页数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _page.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

//创建分页视图
- (void)createPageView{
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, kScrollViewHeight, kScreenWidth, kPageControllerHeight)];
    _page.backgroundColor = [UIColor blackColor];
    //设置分页数
    _page.numberOfPages = (_emoticonArray.count - 1)/32 +1;
    //设置当前页数
    _page.currentPage = 0;
    [self addSubview:_page];
}

@end
