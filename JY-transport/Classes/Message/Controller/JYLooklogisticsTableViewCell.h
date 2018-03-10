//
//  JYLooklogisticsTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYOrderDetailModel.h"

@interface JYLooklogisticsTableViewCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UILabel *statusName;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *logName;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (nonatomic,strong)JYOrderDetailModel *model;

@end
