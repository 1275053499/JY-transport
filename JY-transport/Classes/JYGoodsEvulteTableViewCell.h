//
//  JYGoodsEvulteTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/26.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGoodsEvulteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *naemLabel;
@property (weak, nonatomic) IBOutlet UITextField *evulteTextfield;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
