//
//  JYSwitchTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
