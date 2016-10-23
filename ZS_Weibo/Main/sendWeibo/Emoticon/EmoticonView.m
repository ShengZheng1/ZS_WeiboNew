//
//  EmoticonView.m
//  ZS_Weibo
//
//  Created by apple on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EmoticonView.h"
#import "EmoticonInputView.h"
#import "Emoticon.h"

@implementation EmoticonView

- (void)drawRect:(CGRect)rect{
    if (_emoticonsArray == nil || _emoticonsArray.count == 0) {
        return;
    }
    //4行 8列
    //i表示第几行 j表示第几列
    for (int i = 0; i <4; i++) {
        for (int j = 0; j < 8; j++) {
            NSInteger index = i*8 + j;
            if (index >= _emoticonsArray.count) {
                //表情绘制完毕
                return;
            }
            //计算图像绘制的frame
            CGRect rect = CGRectMake(j*kEmoticonWidth, i*kEmoticonWidth, kEmoticonWidth, kEmoticonWidth);
            //获取表情对象
            Emoticon *emoticon = _emoticonsArray[index];
            //获取图片
            UIImage *image = emoticon.emoticonImage;
            //绘制图片
            [image drawInRect:rect];
        }
    }
}

- (void)setEmoticonsArray:(NSArray *)emoticonsArray{
    //改变数据 重新绘制
    if(_emoticonsArray != emoticonsArray && emoticonsArray.count >0 && emoticonsArray.count <=32)
    {
        _emoticonsArray = [emoticonsArray copy];
        
        //刷新界面
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取手指触摸位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //根据手指位置，判断表情
    int i = point.y / kEmoticonWidth;
    int j = point.x / kEmoticonWidth;
    NSInteger index = i*8 +j;
    //获取表情
    if (index <_emoticonsArray.count) {
        Emoticon *emoticon = _emoticonsArray[index];
        NSLog(@"%@",emoticon.chs);
    }
    
    
    
}

@end
