//
//  EmoticonInputView.h
//  ZS_Weibo
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

/*
 1键盘切换
 2表情数据读取
 3显示表情图
 4点击表情，输出文本
 */

#import <MapKit/MapKit.h>
#define kEmoticonWidth (kScreenWidth/8) //单个表情宽度
#define kPageControllerHeight 20
#define kScrollViewHeight (kEmoticonWidth*4)
#define kEmoticonInputViewHeight (kScrollViewHeight + kPageControllerHeight)
@interface EmoticonInputView : MKAnnotationView<UIScrollViewDelegate>


{
    NSArray *_emoticonArray;
    UIScrollView *_scrollView;
    UIPageControl *_page;
}
@end
