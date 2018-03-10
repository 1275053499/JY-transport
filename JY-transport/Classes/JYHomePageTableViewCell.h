//
//  JYHomePageTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYMessageModel;

@interface JYHomePageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endSubLabel;

@property (nonatomic,strong)JYMessageModel *messageModel;
@property (weak, nonatomic) IBOutlet UILabel *statusType;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;
@end
