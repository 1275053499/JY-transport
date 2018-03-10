//
//  JYAccountTool.m
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//
#define DF_userName @"userName"
#define IWAccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]
#import "JYAccountTool.h"
#import "UserInfoModel.h"
#import "ModelOfUserInfo.h"
@implementation JYAccountTool

+ (id)shareInstance{
    
    static JYAccountTool *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (helper == nil) {
            helper = [[JYAccountTool alloc]init];
        }
        
    });
    return  helper;
}


+ (void)deleteAccount
{
    NSError *error;
    BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:IWAccountFile error:&error];
    if (isDelete) {
        NSLog(@"清除账号成功");
    }else{
        NSLog(@"清除账号失败");
    }
}

+ (void)saveAccount:(ModelOfUserInfo *)account
{
    if (account == nil) {
    
        return;
    }
    [NSKeyedArchiver archiveRootObject:account toFile:IWAccountFile];
}


+ (ModelOfUserInfo *)account
{
    // 取出账号
    ModelOfUserInfo *account = [NSKeyedUnarchiver unarchiveObjectWithFile:IWAccountFile];
    
    return account;
}

+(void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:DF_userName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

+(NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DF_userName];
}

+ (void)deleteJYAccount
{
//    BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:IWAccountFile error:&error];
    
      [[NSUserDefaults standardUserDefaults]removeObjectForKey:DF_userName];
    
 

}
- (UserInfoModel*)getUserInfoModelInfo{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"userInfo.data"];
    
    UserInfoModel *userInfomodel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    return userInfomodel;
}

- (void)saveUserInfoModel:(UserInfoModel *)model{
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 2.2.获得文件的全路径
    NSString *path = [doc stringByAppendingPathComponent:@"userInfo.data"];
    // 2.3.将对象归档
    [NSKeyedArchiver archiveRootObject:model toFile:path];
    
}

@end
