//
//  GlobalFile.h
//  ERAPP
//
//  Created by PeterZhang on 15/11/19.
//  Copyright © 2015年 PeterZhang. All rights reserved.
//

#ifndef GlobalFile_h
#define GlobalFile_h

//***************************************  SFHFKeychainUtils  ********************************
#define SetKeychainForKey(userName,passWord) [SFHFKeychainUtils storeUsername:userName andPassword:passWord forServiceName:AppIdentifier updateExisting:YES error:nil]
#define GetKeychainForKey(userName) [SFHFKeychainUtils getPasswordForUsername:userName andServiceName:AppIdentifier error:nil]
#define DeleteKeychainForKey(userName) [SFHFKeychainUtils deleteItemForUsername:userName andServiceName:AppIdentifier error:nil]
#define AppIdentifier [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundleIdentifier]]

//******************NSUserDefault*******************
#define userD_userName              @"userName"
#define userD_password              @"password"
#define userD_uuid                  @"uuid"
#define userD_ticket                @"ticket"
#define USER_NEED_LOGIN             @"isNeedLogin"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
//#define StateBarHeight (IOS_VERSION >= 7.0f ? 20: 0)
#define ViewHeight self.view.frame.size.height


 #define StateBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

//导航栏高度
#define NavigationBarHeight 44

#define NavigationBarHeight64 64
#define isiPhone6 (([[UIScreen mainScreen] bounds].size.width>320)&&([[UIScreen mainScreen] bounds].size.width<=375))
#define isiPhone6Plus (([[UIScreen mainScreen] bounds].size.width>375)&&([[UIScreen mainScreen] bounds].size.width<=414))

//页面大小缩放比例
#define VER_SCALE (ScreenHeight/667.0)
#define HOR_SCALE (ScreenWidth/375.0)

#define isiPhone5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define isiPhone4 ([[UIScreen mainScreen] bounds].size.height <568)

#define  iPhone4Weight 320.0
#define  iPhone4Height 480.0

#define  iPhone5Weight 320.0
#define  iPhone5Height 568.0

#define  iPhone6Weight 375.0
#define  iPhone6Height 667.0

#define  iPhone6PWeight 414.0
#define  iPhone6PHeight 736.0

#define  iphone5BasicHeight   (1/iPhone5Height*(isiPhone4?iPhone5Height:ScreenHeight))
#define  iphone5BasicWeight   (1/iPhone5Weight*ScreenWidth)
#define  BasicHeight  (1/iPhone6Height*(isiPhone4?iPhone5Height:ScreenHeight))
#define  BasicWidth  (1/iPhone6Weight*ScreenWidth)


// IOS 7
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
// 获取IOS系统版本号
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

//版本信息
#define CFBundleDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define CFBundleShortVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define CFBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define scale_screen  [UIScreen mainScreen].scale

//颜色和透明度设置
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define BGBlue [UIColor colorWithRed:0.0/255.0 green:144.0/255.0 blue:255/255.0 alpha:1.0]

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifdef DEBUG
#define DLog(...) NSLog((@"%s [Line %d] %@"), __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define DLog(...)
#define NSLog(...)
#define debugMethod()
#endif

#define showAlert(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]; [alert show]; }

#define showTitleAlert(title,fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:title, ##__VA_ARGS__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]; [alert show]; }

//tabBar
#define K_TAB_BAR_ITEM_ARRAY_FILE_NAME @"custom_tab_bar_array.plist"
#define K_TAB_BAR_ITEM_DEFAULT_IMAGE @"K_TAB_BAR_ITEM_DEFAULT_IMAGE"
#define K_TAB_BAR_ITEM_DEFAULT_HEIGHTLIGHT_IMAGE @"K_TAB_BAR_ITEM_DEFAULT_HEIGHTLIGHT_IMAGE"
#define K_TAB_BAR_ITEM_DEFAULT_TEXT @"K_TAB_BAR_ITEM_DEFAULT_TEXT"

//***********************通知名称************************//
#define LOGIN_SUCCESS_NOTIFICATION @"LoinSuccessNotification"
#define LOGIN_OUT_NOTIFICATION @"LoginOutNotification"

#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self

#endif
