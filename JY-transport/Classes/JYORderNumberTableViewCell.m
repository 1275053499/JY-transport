//
//  JYORderNumberTableViewCell.m
//  JY-transport
//
//  Created by 闫振 on 2017/9/2.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYORderNumberTableViewCell.h"
#import "JYOrderDetailModel.h"
@implementation JYORderNumberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(JYOrderDetailModel *)model{
    
    _model = model;
    _orderTime.text = model.orderTime;
    _orderNumber.text = model.orderNo;
    if ([model.orderType isEqualToString:@"2"]) {
        
        [self orderStatusName:model];
    }else if ([model.orderType isEqualToString:@"1"]){
        
        [self orderStatusNameForHongKong:model];
    }

    
}
- (void)orderStatusNameForHongKong:(JYOrderDetailModel *)messageModel{
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _ordetStutas.text = @"等待接单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"] || [messageModel.orderStatus isEqualToString:@"2"] ||[messageModel.orderStatus isEqualToString:@"3"] || [messageModel.orderStatus isEqualToString:@"7"]){
        _ordetStutas.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _ordetStutas.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _ordetStutas.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _ordetStutas.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _ordetStutas.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _ordetStutas.text = @"已评价";
        
    }else{
        _ordetStutas.text = @"状态异常";
    }
    
}
- (void)orderStatusName:(JYOrderDetailModel *)messageModel{
    
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _ordetStutas.text = @"等待抢单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"]){
        
        _ordetStutas.text = @"等待估价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"2"] || [messageModel.orderStatus isEqualToString:@"7"]){
        
        _ordetStutas.text = @"等待确认";
        
    }else if ([messageModel.orderStatus isEqualToString:@"3"]){
        
        _ordetStutas.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _ordetStutas.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _ordetStutas.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _ordetStutas.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _ordetStutas.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _ordetStutas.text = @"已评价";
        
    }else{
        _ordetStutas.text = @"状态异常";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
