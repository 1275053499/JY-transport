//
//  OrderHeardTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/10/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderHeardTableViewCell.h"

@implementation OrderHeardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderHeardTableViewCell";
    OrderHeardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
- (void)setModel:(OrderModel *)model{
   
    
    if (model.jyTruckergroup.isCollection == nil ||[model.jyTruckergroup.isCollection isEqual:[NSNull null]] || [model.jyTruckergroup.isCollection isEqualToString:@"0"]) {
        [_collectionBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    }else{
        [_collectionBtn setImage:[UIImage imageNamed:@"collect_select"] forState:UIControlStateNormal];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
