//
//  NetWorkHelper.m
//  IntelligentAssistent
//
//  Created by xylt on 16/5/5.
//  Copyright © 2016年 Qingyi.H. All rights reserved.
//

#import "NetWorkHelper.h"
#import "AFNetworking.h"
#import "AFAppDotNetAPIClient.h"

@implementation NetWorkHelper

+ (id)shareInstance{
    
    static NetWorkHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[NetWorkHelper alloc]init];
        }
        
    });
    return  helper;
}

- (void)Get:(NSString *)url
  parameter:(NSDictionary *)parameter
    success:(void(^)(id responseObj))success
    failure:(void(^)(NSError *error))failure;
{
    
    AFNetworkReachabilityManager *nett = [AFNetworkReachabilityManager sharedManager];
    [nett startMonitoring];
    if (nett.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable  ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noWork" object:nil];
        return;
    }

    //错误调试
    NSAssert(url != nil && url.length > 0, @"URL 不能为空");
    
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时长
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      
        NSDictionary *target;
        NSString *str;
        BOOL isStr = NO;
        
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            
            target = responseObject;
            
        }else if ([responseObject isKindOfClass:[NSData class]]){
            
            
            NSError *error;
            target = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            
            if(!target)
            {
                isStr = YES;
                str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (!str) {
                    str = [responseObject base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                }
            }
            
            
        }else if ([responseObject isKindOfClass:[NSString class]]){
            
            str = responseObject;
            isStr = YES;
        }
        
        if (success) {
            if (isStr) {
                success(str);
            }else{
                success(target);
                
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
    
}


- (void)Post:(NSString *)url
   parameter:(id)parameter
     success:(void(^)(id responseObj))success
     failure:(void(^)(NSError *error))failure
{
    
    AFNetworkReachabilityManager *nett = [AFNetworkReachabilityManager sharedManager];
    [nett startMonitoring];
    if (nett.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable  ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noWork" object:nil];
        return;
    }

    //错误调试
    NSAssert(url != nil && url.length > 0, @"URL 不能为空");
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
       
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时长
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *target;
        NSString *str;
        BOOL isStr = NO;
      
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            
            target = responseObject;
            
            
        }else if ([responseObject isKindOfClass:[NSData class]]){
        
            NSError *error;
            target = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            
       if(!target)
            {
                isStr = YES;
                str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                if (!str) {
                    str = [responseObject base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                }

            }

        
        }else if ([responseObject isKindOfClass:[NSString class]]){
            
            str = responseObject;
            isStr = YES;
        }

            
            if (success) {
                if (isStr) {
                    success(str);
                }else{
                    success(target);
                    
                    
                }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
    
    
}



- (void)Post:(NSString *)url
   parameter:(NSDictionary *)parameter
        data:(NSData *)fileData
        name:(NSString *)name
    fileName:(NSString *)fileName
    mimeType:(NSString *)mimeType
     success:(void(^)(id responseObj))success
     failure:(void(^)(NSError *error))failure
{
    
    AFNetworkReachabilityManager *nett = [AFNetworkReachabilityManager sharedManager];
    [nett startMonitoring];
    if (nett.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable  ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noWork" object:nil];
        return;
    }

    //错误调试
    NSAssert(url != nil && url.length > 0, @"URL 不能为空");
    
    AFHTTPSessionManager *manager = [AFAppDotNetAPIClient sharedClient];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //设置超时时长
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 8.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager POST:url parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //
        //        UIImage *image =[UIImage imageNamed:@"moon"];
        //        NSData *data = UIImagePNGRepresentation(image);
        //
        //
        //        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        //        // 要解决此问题，
        //        // 可以在上传时使用当前的系统事件作为文件名
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置时间格式
        //        formatter.dateFormat = @"yyyyMMddHHmmss";
        //        NSString *str = [formatter stringFromDate:[NSDate date]];
        //        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        //
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        // 给Progress添加监听 KVO
        //  NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self.progressView.progress = 1.0 *
        //            uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        //        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
             // [rightView sd_setImageWithURL:[NSURL URLWithString:userInfo.iconUrl] placeholderImage:[UIImage imageNamed:@"mine_head_n"]];
        
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}
@end
