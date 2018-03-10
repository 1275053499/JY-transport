//
//  JYGrabTableViewCellSecond.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.

#import <UIKit/UIKit.h>
@class JYOrderDetailModel;
@interface JYGrabTableViewCellSecond : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sendTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *graylineView;

@property (weak, nonatomic) IBOutlet UILabel *CityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityTypeLabel;

@property (nonatomic,strong)JYOrderDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
