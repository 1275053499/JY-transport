//
//  JYWaitingAnimationViewController.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYWaitingAnimationViewController : UIViewController
@property (nonatomic,strong)NSString *orderID;//订单id
@property (nonatomic,strong)NSString *startProvice;//起点省份信息
@property (nonatomic,strong)NSString *endProvice;//终点省份信息
@property (nonatomic,strong)NSString *orderDetailType;//当前在哪个页面 动画。确认价格。确认订单
@end
