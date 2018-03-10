//
//  JYLooklogisticsTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/5.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYLooklogisticsTableViewCell.h"

@implementation JYLooklogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYLooklogisticsTableViewCell";
    JYLooklogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}
- (void)setModel:(JYOrderDetailModel *)model{
    
    _model = model;
    self.statusName.text = @"物流状态：";
    self.statusName.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    self.statusName.textColor = RGB(51, 51, 51);
    self.statusLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    _statusLabel.textColor = BGBlue;

    self.orderName.text = @"订单编号：";
    self.orderName.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    self.orderName.textColor = RGB(51, 51, 51);
    
    self.orderLabel.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    self.orderLabel.textColor = RGB(51, 51, 51);
    _orderLabel.text = model.transportNumber;


    
    self.logName.text = @"下单时间：";
    self.logName.font = [UIFont fontWithName:Default_APP_Font_Regu size:14];
    self.logName.textColor = RGB(51, 51, 51);
    _logLabel.textColor = RGB(51, 51, 51);
    _logLabel.text = model.orderTime;

    
    if ([model.orderType isEqualToString:@"1"]) {
        
        [self orderStatusName:model];
    }else if ([model.orderType isEqualToString:@"2"]){
        
        [self orderStatusNameForHongKong:model];
    }
    
    
}
- (void)orderStatusNameForHongKong:(JYOrderDetailModel *)messageModel{
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _statusLabel.text = @"等待接单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"] || [messageModel.orderStatus isEqualToString:@"2"] ||[messageModel.orderStatus isEqualToString:@"3"] || [messageModel.orderStatus isEqualToString:@"7"]){
        _statusLabel.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _statusLabel.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _statusLabel.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _statusLabel.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _statusLabel.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _statusLabel.text = @"已评价";
        
    }else{
        _statusLabel.text = @"状态异常";
    }
    
}
- (void)orderStatusName:(JYOrderDetailModel *)messageModel{
    
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _statusLabel.text = @"等待抢单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"]){
        
        _statusLabel.text = @"等待估价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"2"] || [messageModel.orderStatus isEqualToString:@"7"]){
        
        _statusLabel.text = @"等待确认";
        
    }else if ([messageModel.orderStatus isEqualToString:@"3"]){
        
        _statusLabel.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _statusLabel.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _statusLabel.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _statusLabel.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _statusLabel.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _statusLabel.text = @"已评价";
        
    }else{
        _statusLabel.text = @"状态异常";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
