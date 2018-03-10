//
//  JYOrderDetailCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYOrderDetailModel;
@interface JYOrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendName;
@property (weak, nonatomic) IBOutlet UILabel *sendPhone;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic,strong)JYOrderDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
