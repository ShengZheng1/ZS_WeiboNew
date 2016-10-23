//
//  WeiboModel.m
//  ZS_Weibo
//
//  Created by apple on 16/10/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WeiboModel.h"
#import "YYModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    //获取字符串
    NSString *weiboText = [self.text copy];
    //字符串内容替换[兔子]  -> <image url = '001.png'>
    //1使用正则表达式，查找表情字符串
    NSString *regex = @"\\[\\w+\\]";
    NSArray *arr = [weiboText componentsMatchedByRegex:regex];
//    NSLog(@"%@",arr);
    //2到plist文件中，查找表情是否存在
    //读取plist文件
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [[NSArray alloc]initWithContentsOfFile:filePath];
    for (NSString *str in arr) {
        //使用谓词来查找相对应的元素
        NSString *s = [NSString stringWithFormat:@"chs = '%@'",str];
        NSPredicate *pre = [NSPredicate predicateWithFormat:s];
        //谓词过滤
        NSArray *result = [emoticons filteredArrayUsingPredicate:pre];
       //获取过滤结果
        NSDictionary *dic = [result firstObject];
        if (dic == nil) {
            //表情在列表中不存在，则忽略此表情
            continue;
        }
        //3如果表情存在，则获取表情文件名，按照格式替换
        NSString *imageName = dic[@"png"];
        //替换后的字符串
        NSString *imageStr = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
        //替换字符串
        weiboText = [weiboText stringByReplacingOccurrencesOfString:str withString:imageStr];
//        NSLog(@"替换成功");
    }
  
    
    
    //重写设置text
    self.text = [weiboText mutableCopy];
    
   
    return YES;
}
@end
