//
//  AppDelegate.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuideViewController.h"
#import "CustomTabBarViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GuideViewController *guideViewController;
@property (strong, nonatomic) CustomTabBarViewController *tabBarController;

@end

