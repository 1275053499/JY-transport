//
//  WithdrawTypeCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/23.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UIImageView *accessImg;
@property (weak, nonatomic) IBOutlet UILabel *chooseAccountLabel;

@end