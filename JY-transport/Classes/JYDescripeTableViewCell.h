//
//  JYDescripeTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/24.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDescripeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *evaluteLabel;

@property (weak, nonatomic) IBOutlet UILabel *naemLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
