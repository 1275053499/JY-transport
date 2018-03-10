//
//  JYSwitchEvulteTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYSwitchEvulteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *evulteLabel;

@property (weak, nonatomic) IBOutlet UILabel *equalLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
