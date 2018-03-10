//
//  WithdrawTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/17.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *type;

@end
