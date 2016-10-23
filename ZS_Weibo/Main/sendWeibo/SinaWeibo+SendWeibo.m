//
//  SinaWeibo+SendWeibo.m
//  ZS_Weibo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SinaWeibo+SendWeibo.h"
#import "AFNetworking.h"
@implementation SinaWeibo (SendWeibo)
//https://api.weibo.com/2/statuses/update.json //上传微博
//https://upload.api.weibo.com/2/statuses/upload.json //上传微博和图片
- (void)sendWeiboWithText:(NSString *)text image:(UIImage *)image params:(NSDictionary *)params success:(SendWeiboSuccessBlock)success fail:(SendWeiboFailBlock)fail{
    
    //处理参数 token
    NSMutableDictionary *mDic = [params mutableCopy];
    [mDic setObject:self.accessToken forKey:@"access_token"];
    [mDic setObject:text forKey:@"status"];
    
    
    if(image){
        //有图片
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:mDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //图片转Data
            NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
            //拼接数据
            [formData appendPartWithFileData:imageData name:@"pic" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (error) {
                fail(error);
            }
        }];
    }else{
        //没图片
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //发送post请求
        [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:mDic success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (error) {
                fail(error);
            }
        }];
    }
}

@end
