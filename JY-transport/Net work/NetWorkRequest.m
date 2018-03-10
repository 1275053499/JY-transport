//
//  NetWorkRequest.m
//  JY-transport
//
//  Created by 闫振 on 2018/3/10.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import "NetWorkRequest.h"
#import "NetWorkHelper.h"
@implementation NetWorkRequest
#pragma mark 获取验证码
+ (void)PostRequestCode:(NSString *)phone success:(void(^)(id responseObj))success
            failure:(void(^)(NSError *error))failure{
    
    NSString *urlStr  = [base_url stringByAppendingString:@"app/user/getVerCode"];
    [[NetWorkHelper shareInstance] Post:urlStr parameter:@{@"phone":phone} success:success failure:failure];
}

#pragma mark 验证验证码
+(void)PostRequestCode:(NSString *)phone verCode:(NSString *)verCode idea:(NSString *)idea success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr  = [base_url stringByAppendingString:@"app/user/checkVerCode"];
    [[NetWorkHelper shareInstance] Post:urlStr parameter:@{@"phone":phone,@"verCode":verCode,@"idea":idea} success:success failure:failure];
}

#pragma mark 查询用户信息
+(void)PostRequestUseInfo:(NSString *)phone success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr  = [base_url stringByAppendingString:@"app/user/getUseInfo"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"phone":phone} success:success failure:failure];
}

#pragma  mark 获取优惠卷list
+(void)PostRequestcpType:(NSString *)cpType success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr  = [base_url stringByAppendingString:@"app/coupon/getCouponList"];
    [[NetWorkHelper shareInstance]Post:urlStr parameter:@{@"cpType":cpType} success:success failure:failure];
}




@end
