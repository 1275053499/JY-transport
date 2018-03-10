//
//  payTypeTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/3.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *seletedButton;
@property (weak, nonatomic) IBOutlet UILabel *detLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImg;
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;
@end
