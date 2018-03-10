//
//  JYShipBaseViewController.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYOrderDetailModel.h"


@interface JYShipBaseViewController : UIViewController
@property (nonatomic,strong)JYOrderDetailModel *detailModel;
@property (nonatomic,strong)NSString *whichType;
@end
