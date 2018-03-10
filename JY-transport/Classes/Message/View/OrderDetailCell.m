//
//  OrderDetailCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderDetailCell.h"
@interface OrderDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *driverName;


@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UILabel *plateNumber;

@end
@implementation OrderDetailCell

+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderDetailCell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}

- (void)setModel:(OrderModel *)model
{

    _model = model;
    
    //self.driverName.text = model.contacts;
    self.phone.text = model.jyTruckergroup.phone;
    self.driverName.text = model.jyTruckergroup.name;
    self.plateNumber.text = model.jyTruckergroup.licensePlate;

   
}


@end
