//
//  EvaluateCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *evaluateLabel;

@property (weak, nonatomic) IBOutlet UIView *SportDetailView;

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@property (weak, nonatomic) IBOutlet UITextField *giveMoneyTextField;
@property (weak, nonatomic) IBOutlet UIView *bootmView;
@property (weak, nonatomic) IBOutlet UIButton *price;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
