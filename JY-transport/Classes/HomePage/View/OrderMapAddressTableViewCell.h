//
//  OrderMapAddressTableViewCell.h
//  JY-transport-driver
//
//  Created by 闫振 on 2017/10/16.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderMapAddressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *startSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *endSubLabel;
@property (nonatomic,strong)OrderModel *model;
@end

