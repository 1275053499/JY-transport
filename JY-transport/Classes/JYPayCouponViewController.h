//
//  JYPayCouponViewController.h
//  JY-transport
//
//  Created by 闫振 on 2018/1/8.
//  Copyright © 2018年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineCouponModel;
@interface JYPayCouponViewController : UIViewController
@property (nonatomic,strong)void(^BlockMineCouponVaule)(MineCouponModel *vaule);

@end
