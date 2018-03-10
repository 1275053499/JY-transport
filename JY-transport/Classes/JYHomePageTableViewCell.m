//
//  JYHomePageTableViewCell.m
//  JY-transport-driver
//
//  Created by 永和丽科技 on 17/8/15.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYHomePageTableViewCell.h"
#import "JYMessageModel.h"
@implementation JYHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithOrderTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYHomePageTableViewCell";
    JYHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMessageModel:(JYMessageModel *)messageModel{    
    
    _messageModel = messageModel;
    //起点终点名字起反了
    _orderNoLabel.text = messageModel.orderNo;
    _startTitleLabel.text = messageModel.destination;
    //  _startTitleLabel.text = @"皓月花园";
    _endTitleLabel.text = messageModel.originatingSite;
//  _endSubLabel.text = @"民治地铁站附近";
    _timeLabel.text = messageModel.orderTime;
//    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",messageModel.evaluation];
//    if (messageModel.evaluation == nil || [messageModel.evaluation isEqual:[NSNull null]]) {
//        _moneyLabel.text = @"";
//    }
    
    if ([messageModel.orderType isEqualToString:@"2"]) {
        [self orderStatusNameForHongKong:messageModel];
    }else if ([messageModel.orderType isEqualToString:@"1"]) {
        
        [self orderStatusName:messageModel];
    }
    
  

}
- (void)orderStatusNameForHongKong:(JYMessageModel *)messageModel{
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _statusType.text = @"等待接单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"] || [messageModel.orderStatus isEqualToString:@"2"] ||[messageModel.orderStatus isEqualToString:@"3"] || [messageModel.orderStatus isEqualToString:@"7"]){
        _statusType.text = @"等待揽件";

    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _statusType.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _statusType.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _statusType.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _statusType.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _statusType.text = @"已评价";
        
    }else{
        _statusType.text = @"状态异常";
    }
    
}
- (void)orderStatusName:(JYMessageModel *)messageModel{
    
    if ([messageModel.orderStatus isEqualToString:@"0"]) {
        _statusType.text = @"等待抢单";
        
    }else if ([messageModel.orderStatus isEqualToString:@"1"]){
        
        _statusType.text = @"等待估价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"2"] || [messageModel.orderStatus isEqualToString:@"7"]){
        
        _statusType.text = @"等待确认";
        
    }else if ([messageModel.orderStatus isEqualToString:@"3"]){
        
        _statusType.text = @"等待揽件";
        
    }else if ([messageModel.orderStatus isEqualToString:@"4"]){
        
        _statusType.text = @"运输中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"5"]){
        
        _statusType.text = @"未评价";
        
    }else if ([messageModel.orderStatus isEqualToString:@"6"]){
        
        _statusType.text = @"已取消";
        
    }else if ([messageModel.orderStatus isEqualToString:@"8"]){
        
        _statusType.text = @"派件中";
        
    }else if ([messageModel.orderStatus isEqualToString:@"9"]){
        
        _statusType.text = @"已评价";
        
    }else{
        _statusType.text = @"状态异常";
    }
}
@end
