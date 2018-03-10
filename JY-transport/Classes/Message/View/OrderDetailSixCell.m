//
//  OrderDetailSixCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/5/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "OrderDetailSixCell.h"
@interface OrderDetailSixCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation OrderDetailSixCell


+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"OrderDetailSixCell";
    OrderDetailSixCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        // cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
        
    }
    return cell;
}


- (void)setModel:(OrderModel *)model
{

    _model = model;
    self.userName.text = model.contacts;
    self.phone.text = model.phone;


}

@end
