//
//  MineIconTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineIconTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
