//
//  OrderDetailSixCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderDetailSixCell : UITableViewCell
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;
@property(nonatomic,strong)OrderModel *model;
@end
