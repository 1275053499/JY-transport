//
//  balanceDetailTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "balanceDetailModel.h"
@interface balanceDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)balanceDetailModel *model;
@end
