//
//  OrderDetailTwoCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderDetailTwoCell : UITableViewCell
//------------------------------
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;

@property (weak, nonatomic) IBOutlet UILabel *orderContent;


- (void)setOrderStutas:(OrderModel *)model;

@end
