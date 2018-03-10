//
//  NetWorkRequest.h
//  JY-transport
//
//  Created by 闫振 on 2018/3/10.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkRequest : NSObject
//获取验证码
+ (void)PostRequestCode:(NSString *)phone success:(void(^)(id responseObj))success
                failure:(void(^)(NSError *error))failure;
//验证验证码
+ (void)PostRequestCode:(NSString *)phone verCode:(NSString *)verCode idea:(NSString *)idea success:(void(^)(id responseObj))success
                failure:(void(^)(NSError *error))failure;

//查询用户信息
+ (void)PostRequestUseInfo:(NSString *)phone success:(void(^)(id responseObj))success
                failure:(void(^)(NSError *error))failure;



















@end
