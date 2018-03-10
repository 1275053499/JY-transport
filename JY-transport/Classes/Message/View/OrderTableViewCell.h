//
//  OrderTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/4/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"


@interface OrderTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)OrderModel *model;
@end
