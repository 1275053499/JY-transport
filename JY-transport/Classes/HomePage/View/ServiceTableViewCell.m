//
//  ServiceTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/10/11.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "ServiceTableViewCell.h"

@implementation ServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ServiceTableViewCell";
    ServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}

- (void)setServiceBtnImage{
    self.leftbtn.tag = 2001;
    self.midbtn.tag = 2002;
    self.rightBtn.tag = 2003;
    [self.leftbtn setImage:[UIImage imageNamed:@"icon_gaosu_huise"] forState:(UIControlStateNormal)];
    [self.leftbtn  setImage:[UIImage imageNamed:@"icon_gaosu"] forState:(UIControlStateSelected)];
    [self.leftbtn setTitle:@" 高速" forState:(UIControlStateNormal)];
    
    [self.midbtn setImage:[UIImage imageNamed:@"icon_xuyaoshoutuiche"] forState:(UIControlStateNormal)];
    [self.midbtn  setImage:[UIImage imageNamed:@"icon_xuyaoshoutuiche_lanse"] forState:(UIControlStateSelected)];
    [self.midbtn setTitle:@" 手推车" forState:(UIControlStateNormal)];

    
    [self.rightBtn setImage:[UIImage imageNamed:@"icon_xuyaobanyun_huise"] forState:(UIControlStateNormal)];
    [self.rightBtn  setImage:[UIImage imageNamed:@"icon_xuyaobanyun"] forState:(UIControlStateSelected)];
    [self.rightBtn setTitle:@" 搬运" forState:(UIControlStateNormal)];

    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
