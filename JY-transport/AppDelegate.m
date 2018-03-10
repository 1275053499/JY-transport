//
//  AppDelegate.m
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/20.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JYAccountTool.h"
#import "ModelOfUserInfo.h"
#import "JYWuliuTool.h"
#import  <AMapFoundationKit/AMapFoundationKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <AlipaySDK/AlipaySDK.h>
#import <AlipaySDK/APayAuthInfo.h>
#import <JPUSHService.h>
#import <AdSupport/AdSupport.h>
#import "HomePageViewController.h"

#import <WXApiObject.h>
#import <WXApi.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "payViewController.h"
#define JpushAppKey @"c8f8054e89452ac38e1c6389"
#define BMKMapKey @"Vg1N6nqhdGqiwi0v0e3ymoS1miRGMfOK"
#define WeiXinPayID @"wx8a2a1f8279c57946"

#import <Bugly/Bugly.h>
#import <IQKeyboardManager.h>
@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate>
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [Bugly startWithAppId:@"283efacd6e"];

    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [AMapServices sharedServices].apiKey = @"5dec1e54b15266b7822061bc08be4bef";
    _mapManager = [[BMKMapManager alloc]init];
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:BMKMapKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    // 先判断有无存储账号信息
    //ModelOfUserInfo *account = [JYAccountTool account];
    NSString *account = [JYAccountTool userName];
    if (account) {// 之前登录成功
        [JYWuliuTool chooseRootController];
        
    }else{// 之前没有登录成功
    
        self.window.rootViewController = [[LoginViewController alloc]init];
    }
    
    //向微信注册wx8a2a1f8279c57946
    [WXApi registerApp:WeiXinPayID];
   
    //注册远程推送
    [self RegisterEntityJPush:launchOptions];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    return YES;
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
- (void)RegisterEntityJPush:(NSDictionary *)launchOptions{
    
    //-------------注册远程推送
    if (IOS_VERSION >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        //-------------注册远程推送
        //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if (IOS_VERSION >= 8.0)
    {
        // categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                              categories:nil];
    }


#ifdef DEBUG
    BOOL isProduction = NO;// NO为开发环境
#else
    BOOL isProduction = YES;// YES为生产环境
#endif  //广告标识符 如果没有使用IDFA直接传nil
    // 获取IDFA
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                          channel:nil
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    //return YES;
    
    // apn 内容获取：
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {  //程序退出未启动  点击通知跳转页面
        
        CustomTabBarViewController *nav = (CustomTabBarViewController*) (self.window.rootViewController);
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
//        [nav presentViewController:bVC animated:YES completion:nil];
        
        // 重置服务器端徽章
        [JPUSHService resetBadge];
    }
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功===：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

}
// 微信支付
- (void)onResp:(BaseResp *)resp {
    
        NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPaySuccess" object:nil];
                
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付结果：用户取消！";
                NSLog(@"用户取消，retcode = %d", resp.errCode);
                
                break;

            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                
                break;
        }
}

//  支付宝
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.scheme isEqualToString:WeiXinPayID]) {
     return   [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                
//               [MBProgressHUD showSuccess:@"支付成功" toView:view];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alPaySuccess" object:nil];
                
            }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
                
                [MBProgressHUD showInfoMessage:@"取消支付"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alPayUserCancel" object:nil];
                
            }else{
                
                [MBProgressHUD showError:@"支付失败"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"alPayPayError" object:nil];
                
            }

        }];
    }else if ([url.scheme isEqualToString:WeiXinPayID]){
         return  [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
#pragma mark =============== 微信支付回调 ===============
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - 处理支付回调、
- (void)handleOpenURl:(NSURL *)url
{
    
    if ([url.host isEqualToString:@"safepay"] ) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            [self handleAlipayResult:resultDic];
        }];
    }
}

#pragma mark - 支付宝支付处理结果
- (void)handleAlipayResult:(NSDictionary *)resultDic
{
    
    if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
        
        
//        [MBProgressHUD showSuccess:@"支付成功" toView:view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"alPaySuccess" object:nil];
        
        
    }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]) {
        
        [MBProgressHUD showInfoMessage:@"取消支付"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXUserCancel" object:nil];
        
        
    }else{
        [MBProgressHUD showError:@"支付失败"];
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPayError" object:nil];
        
    }
}


//将苹果服务器返回的deviceToken,上传到极光推送服务器。

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];

}
//注册远程通知失败，比如没有联网的状态下。
-(void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate  ios 10
//前台收到推送，可以采取必要的措施处理通知和更新APP的内容。
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
     NSLog(@"推送消息333333333===%@",userInfo);
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    // 指定系统如何提醒用户，有Badge、Sound、Alert三种类型可以设置
    // 如果不需提醒可传UNNotificationPresentationOptionNone
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
//当用户点击了通知的某个操作，需要进行相应处理，如跳转到某个界面
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
     NSLog(@"推送消息呢111111===%@",userInfo);
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 让系统知道你已处理完通知。
    completionHandler();
}
#endif
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(void)registerDeviced:(NSNotification *)notification
{
    [JPUSHService registrationID];
    NSLog(@"registrationID:%@",[JPUSHService registrationID]);
    //在登录成功对应的方法中设置标签及别名
    /**tags alias
     *空字符串（@“”）表示取消之前的设置
     *nil,此次调用不设置此值
     *每次调用设置有效的别名，覆盖之前的设置
     */
    NSString *alias = @"hello";
    [JPUSHService setTags:nil alias:alias fetchCompletionHandle:^(int iResCode,NSSet *iTags, NSString *iAlias) {
        
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);//对应的状态码返回为0，代表成功
    }];
}
//所有人 前台收到通知   点击通知
//iOS7 ~ iOS9  前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"iOS7推送消息呢===%@",userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    [JPUSHService handleRemoteNotification:userInfo];
    application.applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    
    
}
//自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
    NSLog(@"自定义消息============%@",userInfo);

    NSString *content_type = [userInfo valueForKey:@"content_type"];
    NSString *title = [userInfo valueForKey:@"title"];
       if ([content_type isEqualToString:@"getDrivers"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getDrivers" object:nil];
       }else if ([content_type isEqualToString:@"reqStarted"] || [content_type isEqualToString:@"endOrder"] || [content_type isEqualToString:@"reqLoading"] || [content_type isEqualToString:@"reqUnloading"]){
           
           [[NSNotificationCenter defaultCenter] postNotificationName:@"getDrivers" object:nil]; //刷新的VC 一样  所以还是用这个方法
       }else if ([title isEqualToString:@"logisticsOrder"] && [content_type isEqualToString:@"acquisitionValuation"]){
           
           //物流公司估价 通知
           [[NSNotificationCenter defaultCenter] postNotificationName:@"getCompanyPrice" object:nil];
       
       }


}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
    //  即将进入前台  取消小红点
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];

    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


@end
