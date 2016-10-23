//
//  WeiboCellLayout.m
//  ZS_Weibo
//
//  Created by apple on 16/10/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WXLabel.h"
@interface WeiboCellLayout()
{
    CGFloat _cellHeight;
}

@end
@implementation WeiboCellLayout
+ (instancetype)layoutWithWeiboModel:(WeiboModel *)weibo{
    WeiboCellLayout *layout = [[WeiboCellLayout alloc]init];
    if (layout) {
        layout.weibo = weibo;
    }
    return layout;
}

//再输入一个Model时，计算Frame
- (void)setWeibo:(WeiboModel *)weibo{
    if (_weibo == weibo) {
        return;
    }
    _weibo = weibo;
    //初始化总高度
    _cellHeight = 0;
    //加上顶部视图高
    _cellHeight += CellTopViewHeight;
    //加上空隙
    _cellHeight += SpaceWidth;
    
    //计算frame
    //--------计算微博正文高度-----------
//    NSDictionary *attributes = @{NSFontAttributeName:kWeiboTextFont};
//    CGRect rect = [_weibo.text boundingRectWithSize:CGSizeMake(kScreenWidth-2*SpaceWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//    CGFloat weiboTextHeight = rect.size.height;
    
    //pointSize字体的实际大小
    CGFloat weiboTextHeight = [WXLabel getTextHeight:kWeiboTextFont.pointSize width:kScreenWidth-2*SpaceWidth text:_weibo.text linespace:LineSpace];
    weiboTextHeight += 5;
    
    
    //文本frame
    _weiboTextFrame = CGRectMake(SpaceWidth, CellTopViewHeight+SpaceWidth, kScreenWidth - 2*SpaceWidth, weiboTextHeight);
    
    _cellHeight += weiboTextHeight;
    
    _cellHeight += SpaceWidth;
    
    //-----------微博图片------------
    //判断是否有图片
    if (_weibo.pic_urls.count > 0) {
        CGFloat imageHeight = [self layoutNineImageViewFrameWithImageCount:_weibo.pic_urls.count viewWidth:(kScreenWidth - 2 * SpaceWidth) top:CGRectGetMaxY(_weiboTextFrame)+SpaceWidth];
        
        _cellHeight += imageHeight;
        _cellHeight += SpaceWidth;
    }
    else{
//        _weiboImageViewFrame = CGRectZero;
        _imageFrameArr = nil;
    }
    
    //---------转发微博正文----------
    if (_weibo.retweeted_status) {
//       NSDictionary *attributes = @{NSFontAttributeName:kReWeiboTextFont};
//       CGRect rect = [_weibo.retweeted_status.text boundingRectWithSize:CGSizeMake(kScreenWidth-4*SpaceWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//        CGFloat reWeiboTextHeight = rect.size.height;
        
        CGFloat reWeiboTextHeight = [WXLabel getTextHeight:kReWeiboTextFont.pointSize width:kScreenWidth-4*SpaceWidth text:_weibo.retweeted_status.text linespace:LineSpace];
        
        
        _reWeiboTextFrame = CGRectMake(2*SpaceWidth, _cellHeight+SpaceWidth, kScreenWidth - 4*SpaceWidth, reWeiboTextHeight);
        //累加总高度
        _cellHeight += reWeiboTextHeight;
        _cellHeight += SpaceWidth*2;
        
    //---------转发微博图片--------------
        CGFloat reImageHeight;
        if (_weibo.retweeted_status.pic_urls.count > 0) {
             reImageHeight = [self layoutNineImageViewFrameWithImageCount:_weibo.retweeted_status.pic_urls.count viewWidth:(kScreenWidth - 4*SpaceWidth) top:(CGRectGetMaxY(_reWeiboTextFrame)+ SpaceWidth)];
            
            _cellHeight += reImageHeight;
            _cellHeight += SpaceWidth;
        }else{
            _reImageFrameArr = nil;
        }
        
    //---------转发微博背景图片-----------
        _reWeiboBgImageViewFrame = CGRectMake(SpaceWidth, _reWeiboTextFrame.origin.y-SpaceWidth, kScreenWidth-2*SpaceWidth, 3*SpaceWidth + _reWeiboTextFrame.size.height + reImageHeight);
        
    }else{
        _reWeiboTextFrame = CGRectZero;
        _reWeiboBgImageViewFrame = CGRectZero;
        
    }
    
}
//获取总高度
- (CGFloat)cellHeight
{
    return _cellHeight;
}

#pragma mark - 九宫格布局
/* imageCount 图片数量
   viewWidth 总视图宽度
   top       最顶部图片y值
*/
- (CGFloat)layoutNineImageViewFrameWithImageCount:(NSInteger)imageCount viewWidth:(CGFloat)viewWidth top:(CGFloat)top{
    //判断图片数量是否合法
    if(imageCount > 9 || imageCount < 0)
    {
        _imageFrameArr = nil;
        return 0;
    }
    //分情况讨论布局条件（行数，列数，每个图片空隙）
    //所有图片的总高度/每一个图片的边长/列数
    CGFloat viewHeight;
    CGFloat imageWidth;
    NSInteger numberofColumn = 2;
    if (imageCount == 1) {
        //一行一列
        numberofColumn =1;
        imageWidth = viewWidth;
        viewHeight = imageWidth;
    }else if(imageCount == 2){
        //一行两列
        imageWidth = (viewWidth - ImageViewSpace)/2;
        viewHeight = imageWidth;
    }else if (imageCount == 4){
        //两行两列
        imageWidth = (viewWidth -ImageViewSpace)/2;
        viewHeight = viewWidth;
    }else{
        imageWidth = (viewWidth - 2*ImageViewSpace)/3;
        numberofColumn = 3;
        //三列
        if (imageCount == 3) {
            //一行
            viewHeight = imageWidth;
        }else if (imageCount <=6){
            //两行
            viewHeight = imageWidth *2 + ImageViewSpace;
        }else{
            //三行
            viewHeight = viewWidth;
        }
    }
    
    //布局视图
    //初始化Array
    NSMutableArray *mArray = [NSMutableArray array];
    
    //循环创建frame
    for (int i = 0 ; i < 9; i++) {
        //如果循环次数大于图片数量
        if(i >= imageCount)
        {
            //添加一个空的frame 到数组
            CGRect frame = CGRectZero;
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        }else{
            //计算当前视图是第几行第几列
            NSInteger row = i / numberofColumn;
            NSInteger column = i % numberofColumn;
            //计算视图frame
            // x = 列号 * （图片宽度 + 空隙宽度）+ leftspace
            // y = 行号 * （图片宽度 + 空隙宽度）+ top
            CGFloat width = imageWidth +ImageViewSpace;
            CGFloat left = (kScreenWidth - viewWidth)/2;
            CGRect frame =CGRectMake(column * width + left, row * width + top, imageWidth, imageWidth);
            [mArray addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    if(_weibo.retweeted_status.pic_urls.count > 0)
    {
        _reImageFrameArr = [mArray copy];
    }
    else{
        _imageFrameArr = [mArray copy];
    }
    return viewHeight;
    
}
@end
