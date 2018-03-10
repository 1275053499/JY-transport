//
//  ContentTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/11/8.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
