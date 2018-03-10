//
//  MineIconTableViewCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "MineIconTableViewCell.h"

@implementation MineIconTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MineIconTableViewCell";
    MineIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
