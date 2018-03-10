//
//  cancelTableCell.h
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/22.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cancelTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *seleImage;

@end
