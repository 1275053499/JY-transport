//
//  JYMyAddressTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/30.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYMyAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *supView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
