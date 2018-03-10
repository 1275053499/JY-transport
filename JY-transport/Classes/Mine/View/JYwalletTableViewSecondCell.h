//
//  JYwalletTableViewSecondCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/28.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYwalletTableViewSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
