//
//  CouponTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/12/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "MineCouponModel.h"
@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CouponTableViewCell";
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}

- (void)setMineCouponModel:(MineCouponModel *)model type:(NSString *)type{
   
    if ([type isEqualToString:@"left"] || [type isEqualToString:@"JYPayCouponViewController"]) {
        
        if ([model.isAvailable isEqualToString:@"0"]) {
           
            self.bgImgView.image = [UIImage imageNamed:@"coupons_bg_highlight"];

        }else{
            
            if ([model.isAvailable isEqualToString:@"1"]) {
                
                self.bgImgView.image = [UIImage imageNamed:@"coupons_bg_disenabled_used"];
                
            }else if([model.isAvailable isEqualToString:@"2"]) {
                
                self.bgImgView.image = [UIImage imageNamed:@"coupons_bg_disenabled_out"];
                
            }
        }
        
    }else if([type isEqualToString:@"right"]){
    
        if ([model.isAvailable isEqualToString:@"1"]) {
           
            self.bgImgView.image = [UIImage imageNamed:@"coupons_bg_disenabled_used"];
            
        }else if([model.isAvailable isEqualToString:@"2"]) {
          
            self.bgImgView.image = [UIImage imageNamed:@"coupons_bg_disenabled_out"];

        }
    }
    
    _typeLabel.text = model.cpLable;
    _timeLabel.text =  [NSString stringWithFormat:@"有效期至%@",model.rcDeadline];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",model.value];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
