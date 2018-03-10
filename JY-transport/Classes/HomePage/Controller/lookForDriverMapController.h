//
//  lookForDriverMapController.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
#import "DriverInfoMode.h"
@interface lookForDriverMapController : UIViewController


@property(nonatomic,copy)NSString *orderNunber;
@property(nonatomic,strong)DriverInfoMode *drModel;
@property(nonatomic,strong)OrderModel *model;
@property(nonatomic,strong)NSString *isAddSureAlertViewStr;// 是否弹出评分视图
@end
