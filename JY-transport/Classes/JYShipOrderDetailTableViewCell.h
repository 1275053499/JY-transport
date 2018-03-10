//
//  JYShipOrderDetailTableViewCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/8/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYShipOrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
