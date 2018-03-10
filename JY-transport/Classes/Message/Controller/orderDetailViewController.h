//
//  orderDetailViewController.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface orderDetailViewController : UIViewController

@property(nonatomic,strong)OrderModel *OrderModel;

@property (nonatomic,strong)NSString *orderNum;
@end
