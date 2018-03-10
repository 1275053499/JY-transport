//
//  MineTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImg;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
