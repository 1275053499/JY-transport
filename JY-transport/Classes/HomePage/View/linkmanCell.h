//
//  linkmanCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface linkmanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UITextField *linkmanName;


@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
