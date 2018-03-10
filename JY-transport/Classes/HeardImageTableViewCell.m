//
//  HeardImageTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/11/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "HeardImageTableViewCell.h"

@implementation HeardImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HeardImageTableViewCell";
    HeardImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
