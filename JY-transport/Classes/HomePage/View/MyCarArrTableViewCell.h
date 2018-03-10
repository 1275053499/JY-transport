//
//  MyCarArrTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/6/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarArrTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bootmView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
