//
//  CarTypeTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/10/12.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface CarTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (nonatomic,strong)OrderModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeightConstraint;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
