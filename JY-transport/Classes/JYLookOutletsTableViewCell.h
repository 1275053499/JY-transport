//
//  JYLookOutletsTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/9/4.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYLookOutletsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *OutletsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *OutletsAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (weak, nonatomic) IBOutlet UIView *supView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@end
