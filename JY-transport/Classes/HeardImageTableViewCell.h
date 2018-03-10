//
//  HeardImageTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/11/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeardImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *heardImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *conentlabel;
@property (weak, nonatomic) IBOutlet UILabel *getLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lookImg;
@property (weak, nonatomic) IBOutlet UIView *supView;

@property (weak, nonatomic) IBOutlet UILabel *lookLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
