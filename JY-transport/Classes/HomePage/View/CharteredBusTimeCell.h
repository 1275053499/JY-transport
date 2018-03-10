//
//  CharteredBusTimeCell.h
//  JY-transport
//
//  Created by 永和丽科技 on 17/5/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharteredBusTimeCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *halfOfDayButton;

@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *halfOfDayBtnImage;
@property (weak, nonatomic) IBOutlet UIButton *dayBtnImage;

@end
