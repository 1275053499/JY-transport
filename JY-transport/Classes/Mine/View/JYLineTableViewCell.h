//
//  JYLineTableViewCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYLineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
