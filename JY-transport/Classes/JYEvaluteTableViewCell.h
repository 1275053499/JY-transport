//
//  JYEvaluteTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYEvaluteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
