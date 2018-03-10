//
//  CarFleetViewController.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//我的车队
//

#import "BaseViewController.h"

@class DriverInfoMode;
@interface CarFleetViewController : BaseViewController

@property (nonatomic,strong)NSString *pushFromVC;
//@property (nonatomic,strong)NSString *vechileTypeStr;
@property (nonatomic,copy)void(^passOnName)(DriverInfoMode *);

@end
