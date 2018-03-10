//
//  SearchOrderViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/12/6.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOrderViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
