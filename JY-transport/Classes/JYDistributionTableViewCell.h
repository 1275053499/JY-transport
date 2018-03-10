//
//  JYDistributionTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDistributionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImgView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
