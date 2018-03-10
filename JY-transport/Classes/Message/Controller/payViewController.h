//
//  payViewController.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"

@interface payViewController : BaseViewController
@property(nonatomic,strong)OrderModel *model;

@property(nonatomic,strong)NSString *pushFromWhichVC;
@end
