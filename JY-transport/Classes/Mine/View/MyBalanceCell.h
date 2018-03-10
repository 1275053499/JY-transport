//
//  MyBalanceCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyNumber;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end
