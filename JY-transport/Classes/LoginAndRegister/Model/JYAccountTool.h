//
//  JYAccountTool.h
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModelOfUserInfo;
@class UserInfoModel;

@interface JYAccountTool : NSObject
/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(ModelOfUserInfo *)account;

/**
 *  返回存储的账号信息
 */
+ (ModelOfUserInfo *)account;

+(void)saveUserName:(NSString *)userName;
+(NSString *)userName;
+ (void)deleteJYAccount;




- (UserInfoModel*)getUserInfoModelInfo;
- (void)saveUserInfoModel:(UserInfoModel *)model;
+ (id)shareInstance;
@end
