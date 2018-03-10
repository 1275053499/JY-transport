//
//  JYShipLineTableViewCell.h
//  JY-transport
//
//  Created by 闫振 on 2017/8/25.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYShipLineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startPlaehoder;
@property (weak, nonatomic) IBOutlet UILabel *endPlaceHoder;

@property (weak, nonatomic) IBOutlet UIButton *lookStartAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookEndAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *startLocationBtn;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *startSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *endSubLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
