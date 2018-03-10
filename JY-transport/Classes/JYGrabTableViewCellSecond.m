//
//  JYGrabTableViewCellSecond.m
//  JY-transport-driver
//
//  Created by 闫振 on 2017/8/31.
//  Copyright © 2017年 永和丽科技. All rights reserved.
//

#import "JYGrabTableViewCellSecond.h"
#import "JYOrderDetailModel.h"
#import "JYServiceProviderModel.h"
@implementation JYGrabTableViewCellSecond

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"JYGrabTableViewCellSecond";
    JYGrabTableViewCellSecond *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:0][0];
    }
    return cell;
    
}
- (void)setModel:(JYOrderDetailModel *)model{
    
    _model = model;
    
    _cityTypeLabel.hidden = YES;
    _CityTimeLabel.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    JYServiceProviderModel *mod = model.jyServiceProvider;
    _valueLabel.text = [NSString stringWithFormat:@"¥%@",mod.evaluation];
    
    if (_model.timeType == 0) {
        
        self.sendTypeLabel.text = @"即时发货";

    }else{
        
        [self sentType:_model];
    }
   
}

- (void)sentType:(JYOrderDetailModel *)model{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDictionary *weekDict = @{@"2" : @"周一", @"3" : @"周二", @"4" : @"周三", @"5" : @"周四", @"6" : @"周五", @"7" : @"周六", @"1" : @"周日"};
    NSDate *date = [format dateFromString:model.deliveryTime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:date];
    NSInteger week = [calendar component:NSCalendarUnitWeekday fromDate:date];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [calendar component:NSCalendarUnitMinute fromDate:date];
    NSString *weekStr = weekDict[[NSString stringWithFormat:@"%ld",week]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld·%ld(%@) %ld:%ld:00",(long)month,(long)day,weekStr,hour,minute];
    self.sendTypeLabel.text = dateStr;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
