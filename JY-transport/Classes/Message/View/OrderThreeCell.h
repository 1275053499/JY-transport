//
//  OrderThreeCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderThreeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UIButton *moneydetailButton;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;

- (void)setDateFromString:(NSString *)str;
@end
