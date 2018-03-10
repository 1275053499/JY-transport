//
//  JYLineTableViewCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLineTableViewCell.h"

@implementation JYLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYLineTableViewCell";
    JYLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
