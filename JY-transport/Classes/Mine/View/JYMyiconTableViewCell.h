//
//  JYMyiconTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYMyiconTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *heardImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
