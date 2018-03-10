//
//  JYWuliuTool.m
//  JY-transport
//
//  Created by 王政的电脑 on 17/4/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYWuliuTool.h"
#import "GuideViewController.h"
#import "CustomTabBarViewController.h"

@implementation JYWuliuTool
/**
 *  选择根控制器
 */
+ (void)chooseRootController
{
    NSString *key = @"CFBundleVersion";
    
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    
    // 获得当前软件的版本号  
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {
        // 显示状态栏
        [UIApplication sharedApplication].statusBarHidden = NO;
        [UIApplication sharedApplication].keyWindow.rootViewController = [[CustomTabBarViewController alloc] init];
    } else { // 新版本
        [UIApplication sharedApplication].keyWindow.rootViewController = [[GuideViewController alloc] init];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
}

@end
