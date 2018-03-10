//
//  JYSwitchTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYSwitchTableViewCell.h"

@implementation JYSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYSwitchTableViewCell";
    JYSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
