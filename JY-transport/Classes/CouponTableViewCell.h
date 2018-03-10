//
//  CouponTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/13.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineCouponModel;
@interface CouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)setMineCouponModel:(MineCouponModel *)model type:(NSString *)type;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
